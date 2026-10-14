enum PaymentStatus { pending, verified, rejected }

extension PaymentStatusLabel on PaymentStatus {
  String get label => switch (this) {
    PaymentStatus.pending => 'Pending',
    PaymentStatus.verified => 'Verified',
    PaymentStatus.rejected => 'Rejected',
  };
  String get bookingLabel => this == PaymentStatus.verified ? 'Approved' : label;
}

DateTime calendarDay(DateTime date) => DateTime(date.year, date.month, date.day);

class AdminTrip {
  final String id, name, destination, description, category, imageAsset;
  final String? imageBase64;
  final DateTime startDate, endDate;
  final int price, capacity;
  final List<String> facilities;
  AdminTrip({required this.id, required this.name, required this.destination,
    required this.description, required this.category, required this.startDate,
    required this.endDate, required this.price, required this.capacity,
    required List<String> facilities, this.imageAsset = 'assets/images/nature.jfif',
    this.imageBase64}) : facilities = List.unmodifiable(facilities);
  int get durationDays => calendarDay(endDate).difference(calendarDay(startDate)).inDays + 1;
  bool completedAt(DateTime date) => calendarDay(endDate).isBefore(calendarDay(date));
  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'destination': destination, 'description': description,
    'category': category, 'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(), 'price': price, 'capacity': capacity,
    'facilities': facilities, 'imageAsset': imageAsset, 'imageBase64': imageBase64,
  };
  factory AdminTrip.fromJson(Map<String, dynamic> j) => AdminTrip(
    id: j['id'] as String, name: j['name'] as String,
    destination: j['destination'] as String, description: j['description'] as String,
    category: j['category'] as String, startDate: DateTime.parse(j['startDate'] as String),
    endDate: DateTime.parse(j['endDate'] as String), price: j['price'] as int,
    capacity: j['capacity'] as int, facilities: List<String>.from(j['facilities'] as List),
    imageAsset: j['imageAsset'] as String, imageBase64: j['imageBase64'] as String?,
  );
}

class AdminUser {
  final String id, name, email, phone;
  final bool active;
  const AdminUser({required this.id, required this.name, required this.email,
    required this.phone, this.active = true});
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email,
    'phone': phone, 'active': active};
  factory AdminUser.fromJson(Map<String, dynamic> j) => AdminUser(
    id: j['id'] as String, name: j['name'] as String, email: j['email'] as String,
    phone: j['phone'] as String, active: j['active'] as bool,
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
  const AdminBooking({required this.id, required this.userId,
    required this.tripSnapshot, required this.participants, required this.amount,
    required this.bookedAt, required this.bankAccount,
    this.paymentStatus = PaymentStatus.pending, this.proofBase64, this.proofAsset,
    this.reviewNote, this.reviewedAt});
  String get tripId => tripSnapshot.id;
  AdminBooking reviewed(PaymentStatus status, DateTime time, String? note) => AdminBooking(
    id: id, userId: userId, tripSnapshot: tripSnapshot, participants: participants,
    amount: amount, bookedAt: bookedAt, bankAccount: bankAccount,
    paymentStatus: status, proofBase64: proofBase64, proofAsset: proofAsset, reviewedAt: time, reviewNote: note,
  );
  Map<String, dynamic> toJson() => {'id': id, 'userId': userId,
    'tripSnapshot': tripSnapshot.toJson(), 'participants': participants, 'amount': amount,
    'bookedAt': bookedAt.toIso8601String(), 'bankAccount': bankAccount,
    'paymentStatus': paymentStatus.name, 'proofBase64': proofBase64, 'proofAsset': proofAsset,
    'reviewNote': reviewNote, 'reviewedAt': reviewedAt?.toIso8601String()};
  factory AdminBooking.fromJson(Map<String, dynamic> j) => AdminBooking(
    id: j['id'] as String, userId: j['userId'] as String,
    tripSnapshot: AdminTrip.fromJson(Map<String, dynamic>.from(j['tripSnapshot'] as Map)),
    participants: j['participants'] as int, amount: j['amount'] as int,
    bookedAt: DateTime.parse(j['bookedAt'] as String), bankAccount: j['bankAccount'] as String,
    paymentStatus: PaymentStatus.values.byName(j['paymentStatus'] as String),
    proofBase64: j['proofBase64'] as String?, proofAsset: j['proofAsset'] as String?, reviewNote: j['reviewNote'] as String?,
    reviewedAt: j['reviewedAt'] == null ? null : DateTime.parse(j['reviewedAt'] as String),
  );
}

class AdminProfile {
  final String name, email, passwordHash, passwordSalt;
  final String? photoBase64;
  const AdminProfile({required this.name, required this.email,
    required this.passwordHash, required this.passwordSalt, this.photoBase64});
  AdminProfile copyWith({String? name, String? email, String? passwordHash,
    String? passwordSalt, String? photoBase64, bool removePhoto = false}) => AdminProfile(
    name: name ?? this.name, email: email ?? this.email,
    passwordHash: passwordHash ?? this.passwordHash,
    passwordSalt: passwordSalt ?? this.passwordSalt,
    photoBase64: removePhoto ? null : photoBase64 ?? this.photoBase64,
  );
  Map<String, dynamic> toJson() => {'name': name, 'email': email,
    'passwordHash': passwordHash, 'passwordSalt': passwordSalt, 'photoBase64': photoBase64};
  factory AdminProfile.fromJson(Map<String, dynamic> j) => AdminProfile(
    name: j['name'] as String, email: j['email'] as String,
    passwordHash: j['passwordHash'] as String, passwordSalt: j['passwordSalt'] as String,
    photoBase64: j['photoBase64'] as String?,
  );
}
