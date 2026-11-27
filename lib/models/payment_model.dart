enum BookingPaymentStatus { pending, verified, rejected }

extension BookingPaymentStatusX on BookingPaymentStatus {
  String get label => switch (this) {
        BookingPaymentStatus.pending => 'Pending',
        BookingPaymentStatus.verified => 'Verified',
        BookingPaymentStatus.rejected => 'Rejected',
      };

  String get ticketLabel => switch (this) {
        BookingPaymentStatus.pending => 'Menunggu Verifikasi',
        BookingPaymentStatus.verified => 'Approved / E-Ticket Aktif',
        BookingPaymentStatus.rejected => 'Ditolak',
      };

  static BookingPaymentStatus fromName(String? value) {
    return BookingPaymentStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => BookingPaymentStatus.pending,
    );
  }
}

class PaymentModel {
  final String bankAccount;
  final int amount;
  final BookingPaymentStatus status;
  final String? proofBase64;
  final String? reviewNote;
  final DateTime? reviewedAt;

  const PaymentModel({
    required this.bankAccount,
    required this.amount,
    this.status = BookingPaymentStatus.pending,
    this.proofBase64,
    this.reviewNote,
    this.reviewedAt,
  });

  Map<String, dynamic> toMap() => {
        'bankAccount': bankAccount,
        'amount': amount,
        'paymentStatus': status.name,
        'proofBase64': proofBase64,
        'reviewNote': reviewNote,
        'reviewedAt': reviewedAt?.toIso8601String(),
      };
}