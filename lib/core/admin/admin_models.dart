import 'package:cloud_firestore/cloud_firestore.dart';

enum PaymentStatus { pending, verified, rejected }

extension PaymentStatusLabel on PaymentStatus {
  String get label => switch (this) {
    PaymentStatus.pending => 'Pending',
    PaymentStatus.verified => 'Verified',
    PaymentStatus.rejected => 'Rejected',
  };
  String get bookingLabel =>
      this == PaymentStatus.verified ? 'Approved' : label;
}

DateTime calendarDay(DateTime date) =>
    DateTime(date.year, date.month, date.day);

class AdminTrip {
  final String id, name, destination, description, category, imageAsset;
  final String? imageBase64;
  final DateTime startDate, endDate;
  final int price, capacity;
  final List<String> facilities;

  AdminTrip({
    required this.id,
    required this.name,
    required this.destination,
    required this.description,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.capacity,
    required List<String> facilities,
    this.imageAsset = 'assets/images/nature.jfif',
    this.imageBase64,
  }) : facilities = List.unmodifiable(facilities);

  int get durationDays =>
      calendarDay(endDate).difference(calendarDay(startDate)).inDays + 1;
  bool completedAt(DateTime date) =>
      calendarDay(endDate).isBefore(calendarDay(date));

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    return DateTime.parse(value.toString());
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'destination': destination,
    'description': description,
    'category': category,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'price': price,
    'capacity': capacity,
    'facilities': facilities,
    'imageAsset': imageAsset,
    'imageBase64': imageBase64,
  };

  factory AdminTrip.fromJson(Map<String, dynamic> j, {String? docId}) =>
      AdminTrip(
        id: (j['id'] as String?) ?? docId ?? '',
        name: j['name'] as String? ?? '',
        destination: j['destination'] as String? ?? '',
        description: j['description'] as String? ?? '',
        category: j['category'] as String? ?? 'Group',
        startDate: _parseDate(j['startDate']),
        endDate: _parseDate(j['endDate']),
        price: (j['price'] as num).toInt(),
        capacity: (j['capacity'] as num).toInt(),
        facilities: List<String>.from(j['facilities'] as List? ?? const []),
        imageAsset: j['imageAsset'] as String? ?? 'assets/images/nature.jfif',
        imageBase64: j['imageBase64'] as String?,
      );
}

class AdminUser {
  final String id, name, email, phone;
  final bool active;

  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.active = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'active': active,
  };

  factory AdminUser.fromJson(Map<String, dynamic> j) => AdminUser(
    id: j['id'] as String,
    name: j['name'] as String,
    email: j['email'] as String,
    phone: j['phone'] as String,
    active: j['active'] as bool,
  );
}

class AdminBooking {
  final String id, userId, bankAccount;
  // Snapshot preserves transaction history after a trip is edited or deleted.
  final AdminTrip tripSnapshot;
  final int participants, amount;
  final DateTime bookedAt;
  final PaymentStatus paymentStatus;
  final String? proofBase64, proofAsset, reviewNote;
  final DateTime? reviewedAt;

  const AdminBooking({
    required this.id,
    required this.userId,
    required this.tripSnapshot,
    required this.participants,
    required this.amount,
    required this.bookedAt,
    required this.bankAccount,
    this.paymentStatus = PaymentStatus.pending,
    this.proofBase64,
    this.proofAsset,
    this.reviewNote,
    this.reviewedAt,
  });

  String get tripId => tripSnapshot.id;

  AdminBooking reviewed(PaymentStatus status, DateTime time, String? note) =>
      AdminBooking(
        id: id,
        userId: userId,
        tripSnapshot: tripSnapshot,
        participants: participants,
        amount: amount,
        bookedAt: bookedAt,
        bankAccount: bankAccount,
        paymentStatus: status,
        proofBase64: proofBase64,
        proofAsset: proofAsset,
        reviewedAt: time,
        reviewNote: note,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'tripSnapshot': tripSnapshot.toJson(),
    'participants': participants,
    'amount': amount,
    'bookedAt': bookedAt.toIso8601String(),
    'bankAccount': bankAccount,
    'paymentStatus': paymentStatus.name,
    'proofBase64': proofBase64,
    'proofAsset': proofAsset,
    'reviewNote': reviewNote,
    'reviewedAt': reviewedAt?.toIso8601String(),
  };

  factory AdminBooking.fromJson(Map<String, dynamic> j, {String? docId}) =>
      AdminBooking(
        id: (j['id'] as String?) ?? docId ?? '',
        userId: (j['userId'] as String?) ?? '',
        tripSnapshot: AdminTrip.fromJson(
          Map<String, dynamic>.from(j['tripSnapshot'] as Map),
        ),
        participants: (j['participants'] as num).toInt(),
        amount: (j['amount'] as num).toInt(),
        bookedAt: AdminTrip._parseDate(j['bookedAt']),
        bankAccount: (j['bankAccount'] as String?) ?? 'BCA • 1234567890',
        paymentStatus: PaymentStatus.values.firstWhere(
          (e) => e.name == j['paymentStatus'],
          orElse: () => PaymentStatus.pending,
        ),
        proofBase64: j['proofBase64'] as String?,
        proofAsset: j['proofAsset'] as String?,
        reviewNote: j['reviewNote'] as String?,
        reviewedAt: j['reviewedAt'] == null
            ? null
            : AdminTrip._parseDate(j['reviewedAt']),
      );
}

class AdminProfile {
  final String name, email, passwordHash, passwordSalt;
  final String? photoBase64;

  const AdminProfile({
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.passwordSalt,
    this.photoBase64,
  });

  AdminProfile copyWith({
    String? name,
    String? email,
    String? passwordHash,
    String? passwordSalt,
    String? photoBase64,
    bool removePhoto = false,
  }) => AdminProfile(
    name: name ?? this.name,
    email: email ?? this.email,
    passwordHash: passwordHash ?? this.passwordHash,
    passwordSalt: passwordSalt ?? this.passwordSalt,
    photoBase64: removePhoto ? null : photoBase64 ?? this.photoBase64,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'passwordHash': passwordHash,
    'passwordSalt': passwordSalt,
    'photoBase64': photoBase64,
  };

  factory AdminProfile.fromJson(Map<String, dynamic> j) => AdminProfile(
    name: j['name'] as String,
    email: j['email'] as String,
    passwordHash: j['passwordHash'] as String,
    passwordSalt: j['passwordSalt'] as String,
    photoBase64: j['photoBase64'] as String?,
  );
}