import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'admin_models.dart';

const demoAdminEmail = 'admin.kayla@beyondwanders.com';
const demoAdminPassword = 'Admin123!';
const lowQuotaThreshold = 3;
const _passwordIterations = 210000;

typedef ReadAdminState = Future<String?> Function();
typedef WriteAdminState = Future<void> Function(String value);

Future<String> _passwordDigest(Map<String, String> values) async {
  final key = await Pbkdf2(macAlgorithm: Hmac.sha256(),
      iterations: _passwordIterations, bits: 256).deriveKey(
    secretKey: SecretKey(utf8.encode(values['password']!)),
    nonce: base64Decode(values['salt']!),
  );
  return base64Encode(await key.extractBytes());
}

class _AdminState {
  List<AdminTrip> trips;
  List<AdminBooking> bookings;
  List<AdminUser> users;
  AdminProfile profile;
  _AdminState(this.trips, this.bookings, this.users, this.profile);
  _AdminState clone() => _AdminState(List.of(trips), List.of(bookings), List.of(users), profile);
  Map<String, dynamic> toJson() => {'schemaVersion': 1,
    'trips': trips.map((t) => t.toJson()).toList(),
    'bookings': bookings.map((b) => b.toJson()).toList(),
    'users': users.map((u) => u.toJson()).toList(), 'profile': profile.toJson()};
  factory _AdminState.fromJson(Map<String, dynamic> j) {
    if (j['schemaVersion'] != 1) throw const FormatException('Unsupported admin data version');
    return _AdminState(
      (j['trips'] as List).map((v) => AdminTrip.fromJson(Map<String, dynamic>.from(v as Map))).toList(),
      (j['bookings'] as List).map((v) => AdminBooking.fromJson(Map<String, dynamic>.from(v as Map))).toList(),
      (j['users'] as List).map((v) => AdminUser.fromJson(Map<String, dynamic>.from(v as Map))).toList(),
      AdminProfile.fromJson(Map<String, dynamic>.from(j['profile'] as Map)),
    );
  }
}

class AdminStore extends ChangeNotifier {
  static final instance = AdminStore();
  final DateTime Function() clock;
  late _AdminState _state;
  ReadAdminState? _read;
  WriteAdminState? _write;
  Future<void> _queue = Future<void>.value();
  bool authenticated = false;
  AdminStore({DateTime Function()? clock}) : clock = clock ?? DateTime.now {
    _state = _seed(this.clock());
  }
  List<AdminTrip> get trips => List.unmodifiable(_state.trips);
  List<AdminBooking> get bookings => List.unmodifiable(_state.bookings);
  List<AdminUser> get users => List.unmodifiable(_state.users);
  AdminProfile get profile => _state.profile;
  List<AdminUser> get activeUsers => users.where((u) => u.active).toList();
  List<AdminBooking> get pendingPayments => bookings.where((b) => b.paymentStatus == PaymentStatus.pending).toList();
  List<AdminBooking> get verifiedPayments => bookings.where((b) => b.paymentStatus == PaymentStatus.verified).toList();
  List<AdminTrip> get lowQuotaTrips => trips.where((t) =>
  !t.completedAt(clock()) && remainingQuota(t) <= lowQuotaThreshold).toList();
  AdminTrip? tripById(String id) {
    for (final trip in trips) { if (trip.id == id) return trip; }
    return null;
  }
  AdminBooking? bookingById(String id) {
    for (final booking in bookings) { if (booking.id == id) return booking; }
    return null;
  }
  AdminUser userById(String id) => users.firstWhere((u) => u.id == id);
  int reservedSeats(String tripId) => bookings.where((b) => b.tripId == tripId &&
      b.paymentStatus != PaymentStatus.rejected).fold(0, (sum, b) => sum + b.participants);
  int remainingQuota(AdminTrip trip) => max(0, trip.capacity - reservedSeats(trip.id));
  List<AdminBooking> bookingsForUser(String id) => bookings.where((b) => b.userId == id).toList();
  List<AdminTrip> searchTrips(String query, {String filter = 'All'}) {
    final q = query.trim().toLowerCase();
    return trips.where((t) {
      final completed = t.completedAt(clock());
      return (filter == 'All' || (filter == 'Selesai' ? completed : !completed)) &&
          '${t.id} ${t.name} ${t.destination} ${t.category}'.toLowerCase().contains(q);
    }).toList();
  }
  List<AdminBooking> searchBookings(String query, {String? userId, PaymentStatus? status}) {
    final q = query.trim().toLowerCase();
    final result = bookings.where((b) {
      final user = userById(b.userId);
      return (userId == null || b.userId == userId) &&
          (status == null || b.paymentStatus == status) &&
          '${b.id} ${user.name} ${user.email} ${b.tripSnapshot.name} ${b.paymentStatus.label} ${b.paymentStatus.bookingLabel}'
              .toLowerCase().contains(q);
    }).toList();
    result.sort((a, b) => b.bookedAt.compareTo(a.bookedAt));
    return result;
  }
  Future<void> initialize({required ReadAdminState read, required WriteAdminState write}) async {
    _read = read; _write = write;
    final value = await _read!();
    if (value != null) {
      final loaded = _AdminState.fromJson(Map<String, dynamic>.from(jsonDecode(value) as Map));
      _validate(loaded);
      _state = loaded;
    } else {
      await write(jsonEncode(_state.toJson()));
    }
    notifyListeners();
  }
  void _validate(_AdminState state) {
    if (state.trips.map((t) => t.id).toSet().length != state.trips.length ||
        state.bookings.map((b) => b.id).toSet().length != state.bookings.length ||
        state.users.map((u) => u.id).toSet().length != state.users.length) {
      throw const FormatException('Duplicate data identifiers');
    }
    for (final b in state.bookings) {
      if (!state.users.any((u) => u.id == b.userId) || b.participants < 1 || b.amount < 1) {
        throw const FormatException('Invalid booking data');
      }
    }
    for (final t in state.trips) {
      if (t.name.trim().isEmpty || t.destination.trim().isEmpty || t.description.trim().isEmpty ||
          t.durationDays < 1 || t.price < 1 || t.capacity < 1 ||
          !['Group', 'Private'].contains(t.category) || t.facilities.isEmpty ||
          t.facilities.any((f) => !['Transport', 'Stay', 'Meals', 'Photos'].contains(f))) {
        throw ArgumentError('Lengkapi data trip, fasilitas, harga, kuota, dan tanggal yang valid.');
      }
      final reserved = state.bookings.where((b) => b.tripId == t.id &&
          b.paymentStatus != PaymentStatus.rejected).fold(0, (sum, b) => sum + b.participants);
      if (t.capacity < reserved) throw ArgumentError('Kuota tidak boleh kurang dari $reserved peserta yang sudah memesan.');
    }
  }
  Future<void> _commit(void Function(_AdminState state) edit) {
    final operation = _queue.then((_) async {
      final next = _state.clone();
      edit(next);
      _validate(next);
      if (_write == null) throw StateError('Penyimpanan belum siap.');
      await _write!(jsonEncode(next.toJson()));
      _state = next;
      notifyListeners();
    });
    _queue = operation.catchError((Object _) {});
    return operation;
  }
  String newTripId() => 'TR-${clock().microsecondsSinceEpoch}-${Random.secure().nextInt(100000)}';
  Future<void> saveTrip(AdminTrip trip, {required bool editing}) => _commit((state) {
    final index = state.trips.indexWhere((t) => t.id == trip.id);
    if (editing) {
      if (index < 0) throw StateError('Trip sudah dihapus.');
      state.trips[index] = trip;
    } else {
      if (index >= 0) throw StateError('ID trip sudah digunakan.');
      state.trips.insert(0, trip);
    }
  });
  Future<void> deleteTrip(String id) => _commit((state) {
    if (!state.trips.any((t) => t.id == id)) throw StateError('Trip sudah dihapus.');
    state.trips.removeWhere((t) => t.id == id);
  });
  Future<void> reviewPayment(String id, PaymentStatus status, {String? note}) => _commit((state) {
    final index = state.bookings.indexWhere((b) => b.id == id);
    if (index < 0) throw StateError('Pesanan tidak ditemukan.');
    if (state.bookings[index].paymentStatus != PaymentStatus.pending) {
      throw StateError('Pembayaran ini sudah diproses.');
    }
    if (status == PaymentStatus.pending) throw ArgumentError('Pilih hasil verifikasi.');
    if (status == PaymentStatus.rejected && (note == null || note.trim().isEmpty)) {
      throw ArgumentError('Tuliskan alasan penolakan.');
    }
    state.bookings[index] = state.bookings[index].reviewed(status, clock(), note?.trim());
  });
  Future<void> updateProfile(String name, String email, {String? photoBase64, bool removePhoto = false}) => _commit((state) {
    if (name.trim().isEmpty || !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.trim())) {
      throw ArgumentError('Nama dan alamat email harus valid.');
    }
    state.profile = state.profile.copyWith(name: name.trim(), email: email.trim(),
        photoBase64: photoBase64, removePhoto: removePhoto);
  });
  Future<bool> checkPassword(String password) async {
    final digest = await compute(_passwordDigest, {'password': password, 'salt': profile.passwordSalt});
    final actual = base64Decode(digest), expected = base64Decode(profile.passwordHash);
    if (actual.length != expected.length) return false;
    var difference = 0;
    for (var i = 0; i < actual.length; i++) { difference |= actual[i] ^ expected[i]; }
    return difference == 0;
  }
  Future<bool> login(String email, String password) async {
    final valid = email.trim().toLowerCase() == profile.email.toLowerCase() && await checkPassword(password);
    authenticated = valid;
    return valid;
  }
  void logout() { authenticated = false; notifyListeners(); }
  Future<void> changePassword(String current, String next, String confirmation) async {
    if (next.length < 8 || !RegExp(r'[A-Za-z]').hasMatch(next) || !RegExp(r'\d').hasMatch(next)) {
      throw ArgumentError('Password minimal 8 karakter, berisi huruf dan angka.');
    }
    if (next != confirmation) throw ArgumentError('Konfirmasi password tidak sama.');
    if (next == current) throw ArgumentError('Password baru harus berbeda.');
    if (!await checkPassword(current)) throw ArgumentError('Password saat ini salah.');
    final oldHash = profile.passwordHash;
    final random = Random.secure();
    final salt = base64Encode(List<int>.generate(16, (_) => random.nextInt(256)));
    final hash = await compute(_passwordDigest, {'password': next, 'salt': salt});
    await _commit((state) {
      if (state.profile.passwordHash != oldHash) throw StateError('Password sudah berubah. Coba lagi.');
      state.profile = state.profile.copyWith(passwordHash: hash, passwordSalt: salt);
    });
  }
}

_AdminState _seed(DateTime now) {
  final today = calendarDay(now);
  AdminTrip trip(String id, String name, String destination, int price, int capacity,
      int start, int end, String asset, {String category = 'Group'}) => AdminTrip(
    id: id, name: name, destination: destination, description:
  'Nikmati perjalanan $name bersama Beyond & Wanders. Paket wisata dengan pendamping dan fasilitas pilihan untuk pengalaman liburan yang nyaman.',
    category: category, startDate: today.add(Duration(days: start)),
    endDate: today.add(Duration(days: end)), price: price, capacity: capacity,
    facilities: ['Transport', 'Stay', 'Meals', 'Photos'], imageAsset: asset,
  );
  final trips = [
    trip('T1', 'Bali Summer Getaway', 'Bali, Indonesia', 1500000, 8, 10, 13, 'assets/images/parbaba.png'),
    trip('T2', 'Lombok Surf & Relax', 'Lombok, Indonesia', 2100000, 5, 18, 21, 'assets/images/sipolha1.png', category: 'Private'),
    trip('T3', 'Nusa Penida Day Trip', 'Nusa Penida', 850000, 10, -10, -10, 'assets/images/sipolha2.png'),
    trip('T4', 'Mount Bromo Sunrise', 'East Java', 1200000, 8, -20, -18, 'assets/images/holbung.png'),
    trip('T5', 'Danau Toba Explorer', 'Samosir, Sumatera Utara', 1800000, 4, 5, 8, 'assets/images/sipolha2.png'),
  ];
  const users = [
    AdminUser(id: 'U1', name: 'Sarah Jenkins', email: 'sarah@example.com', phone: '081234567801'),
    AdminUser(id: 'U2', name: 'Jessica Alba', email: 'jessica@example.com', phone: '081234567802'),
    AdminUser(id: 'U3', name: 'Amanda Smith', email: 'amanda@example.com', phone: '081234567803'),
    AdminUser(id: 'U4', name: 'John Doe', email: 'john@example.com', phone: '081234567804', active: false),
  ];
  AdminBooking booking(String id, String user, AdminTrip trip, int pax, int days,
      PaymentStatus status) => AdminBooking(id: id, userId: user, tripSnapshot: trip,
    participants: pax, amount: trip.price * pax, bookedAt: now.subtract(Duration(days: days)),
    bankAccount: 'BCA • 1234567890', paymentStatus: status,
    proofAsset: 'assets/images/demo_receipt.png',
    reviewedAt: status == PaymentStatus.verified ? now.subtract(Duration(days: days - 1)) : null,
  );
  return _AdminState(trips, [
    booking('BK-9921', 'U1', trips[0], 2, 1, PaymentStatus.pending),
    booking('BK-9920', 'U2', trips[1], 2, 3, PaymentStatus.verified),
    booking('BK-9919', 'U3', trips[2], 1, 15, PaymentStatus.verified),
    booking('BK-9918', 'U4', trips[3], 2, 25, PaymentStatus.verified),
    booking('BK-9922', 'U3', trips[4], 2, 0, PaymentStatus.pending),
    booking('BK-9917', 'U1', trips[0], 1, 5, PaymentStatus.rejected),
  ], List.of(users), const AdminProfile(name: 'Kayla Andhara', email: demoAdminEmail,
      passwordSalt: 'Ynd3LWRlbW8tc2FsdC12MQ==', passwordHash: '2EPxLDpAoLhScr8Bd+mI1LDNq3L53Q8AJRkN7XFNYBY='));
}
