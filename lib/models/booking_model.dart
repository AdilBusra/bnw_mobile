import 'package:cloud_firestore/cloud_firestore.dart';
import 'payment_model.dart';

class BookingModel {
  final String id;
  final String userId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String tripCategory;
  final String selectedDate;
  final Map<String, dynamic> tripSnapshot;
  final int participants;
  final int amount;
  final DateTime bookedAt;
  final String bankAccount;
  final BookingPaymentStatus paymentStatus;
  final String? proofBase64;
  final String? reviewNote;
  final DateTime? reviewedAt;

  const BookingModel({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.tripCategory,
    required this.selectedDate,
    required this.tripSnapshot,
    required this.participants,
    required this.amount,
    required this.bookedAt,
    this.bankAccount = 'BCA • 1234567890',
    this.paymentStatus = BookingPaymentStatus.pending,
    this.proofBase64,
    this.reviewNote,
    this.reviewedAt,
  });

  String get tripId => (tripSnapshot['id'] ?? '').toString();
  String get tripTitle => (tripSnapshot['name'] ?? tripSnapshot['title'] ?? 'Trip').toString();
  String get tripLocation => (tripSnapshot['destination'] ?? tripSnapshot['location'] ?? '').toString();
  String get tripImageAsset => (tripSnapshot['imageAsset'] ?? 'assets/images/nature.jfif').toString();
  String? get tripImageBase64 => tripSnapshot['imageBase64'] as String?;
  


  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'customerName': customerName,
        'customerEmail': customerEmail,
        'customerPhone': customerPhone,
        'tripCategory': tripCategory,
        'selectedDate': selectedDate,
        'tripSnapshot': tripSnapshot,
        'participants': participants,
        'amount': amount,
        'bookedAt': bookedAt.toIso8601String(),
        'bankAccount': bankAccount,
        'paymentStatus': paymentStatus.name,
        'proofBase64': proofBase64,
        'proofAsset': null,
        'reviewNote': reviewNote,
        'reviewedAt': reviewedAt?.toIso8601String(),
      };

  factory BookingModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    final snapshot = json['tripSnapshot'] is Map
        ? Map<String, dynamic>.from(json['tripSnapshot'] as Map)
        : <String, dynamic>{};

    return BookingModel(
      id: (json['id'] as String?) ?? docId ?? '',
      userId: (json['userId'] as String?) ?? '',
      customerName: (json['customerName'] as String?) ?? 'Customer',
      customerEmail: (json['customerEmail'] as String?) ?? '',
      customerPhone: (json['customerPhone'] as String?) ?? '',
      tripCategory: (json['tripCategory'] as String?) ?? (snapshot['category'] as String? ?? 'Open Trip'),
      selectedDate: (json['selectedDate'] as String?) ?? '',
      tripSnapshot: snapshot,
      participants: json['participants'] is num
          ? (json['participants'] as num).toInt()
          : int.tryParse(json['participants']?.toString() ?? '') ?? 1,
      amount: json['amount'] is num
          ? (json['amount'] as num).toInt()
          : int.tryParse(json['amount']?.toString() ?? '') ?? 0,
      bookedAt: _parseDate(json['bookedAt']),
      bankAccount: (json['bankAccount'] as String?) ?? 'BCA • 1234567890',
      paymentStatus: BookingPaymentStatusX.fromName(json['paymentStatus'] as String?),
      proofBase64: json['proofBase64'] as String?,
      reviewNote: json['reviewNote'] as String?,
      reviewedAt: json['reviewedAt'] == null ? null : _parseDate(json['reviewedAt']),
    );
  }
}