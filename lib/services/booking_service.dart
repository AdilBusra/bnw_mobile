import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/booking_model.dart';
import '../models/payment_model.dart';

class BookingService {
  static final CollectionReference _bookingsRef =
      FirebaseFirestore.instance.collection('bookings');

  static String formatRupiah(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return 'Rp $buffer';
  }

  /// CREATE: Simpan booking baru beserta bukti pembayaran ke Firestore
  static Future<BookingModel> createBooking({
    required Map<String, dynamic> trip,
    required String customerName,
    required String customerPhone,
    required String tripCategory,
    required String selectedDate,
    required int participants,
    required int totalAmount,
    required String proofBase64,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final now = DateTime.now();
    final bookingId = 'BK-${now.millisecondsSinceEpoch}';

    final rawPrice = trip['rawPrice'] is num
        ? (trip['rawPrice'] as num).toInt()
        : int.tryParse(
              (trip['price'] ?? '0').toString().replaceAll(RegExp(r'[^0-9]'), ''),
            ) ??
            0;

    final rawCapacity = trip['capacity'] is num
        ? (trip['capacity'] as num).toInt()
        : int.tryParse(trip['capacity']?.toString() ?? '') ?? 10;

    // Susun snapshot sesuai struktur AdminTrip.toJson() tanpa imageBase64 agar ukuran dokumen tetap ringan
    final tripSnapshot = <String, dynamic>{
      'id': (trip['id'] ?? 'TR-${now.millisecondsSinceEpoch}').toString(),
      'name': (trip['title'] ?? trip['name'] ?? 'Untitled Trip').toString(),
      'destination': (trip['location'] ?? trip['destination'] ?? '').toString(),
      'description': (trip['description'] ?? 'Paket wisata Beyond & Wanders.').toString(),
      'category': (trip['category'] ?? 'Group') == 'Private' ? 'Private' : 'Group',
      'startDate': now.add(const Duration(days: 3)).toIso8601String(),
      'endDate': now.add(const Duration(days: 5)).toIso8601String(),
      'price': rawPrice > 0 ? rawPrice : (totalAmount ~/ participants),
      'capacity': rawCapacity > 0 ? rawCapacity : 10,
      'facilities': (trip['facilities'] is List && (trip['facilities'] as List).isNotEmpty)
          ? List<String>.from(trip['facilities'] as List)
          : ['Transport', 'Stay', 'Meals', 'Photos'],
      'imageAsset': (trip['image'] ?? 'assets/images/nature.jfif').toString(),
      'imageBase64': null,
    };

    final booking = BookingModel(
      id: bookingId,
      userId: currentUser?.uid ?? 'guest',
      customerName: customerName.trim(),
      customerEmail: currentUser?.email ?? '-',
      customerPhone: customerPhone.trim(),
      tripCategory: tripCategory,
      selectedDate: selectedDate,
      tripSnapshot: tripSnapshot,
      participants: participants,
      amount: totalAmount,
      bookedAt: now,
      paymentStatus: BookingPaymentStatus.pending,
      proofBase64: proofBase64,
    );

    await _bookingsRef.doc(bookingId).set(booking.toJson());
    return booking;
  }

  /// READ: Stream daftar booking milik customer yang sedang login
  static Stream<List<BookingModel>> customerBookingsStream(String userId) {
    return _bookingsRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map(
            (doc) => BookingModel.fromJson(
              Map<String, dynamic>.from(doc.data() as Map),
              docId: doc.id,
            ),
          )
          .toList();
      list.sort((a, b) => b.bookedAt.compareTo(a.bookedAt));
      return list;
    });
  }

  /// UPDATE (Customer): Unggah ulang bukti bayar jika status masih pending/rejected
  static Future<void> reuploadPaymentProof({
    required String bookingId,
    required String proofBase64,
  }) async {
    await _bookingsRef.doc(bookingId).update({
      'proofBase64': proofBase64,
      'paymentStatus': BookingPaymentStatus.pending.name,
      'reviewNote': null,
      'reviewedAt': null,
    });
  }

  /// UPDATE (Admin): Verifikasi atau tolak pembayaran
  static Future<void> reviewPayment({
    required String bookingId,
    required BookingPaymentStatus status,
    String? reviewNote,
  }) async {
    await _bookingsRef.doc(bookingId).update({
      'paymentStatus': status.name,
      'reviewNote': reviewNote,
      'reviewedAt': DateTime.now().toIso8601String(),
    });
  }

  /// DELETE: Batalkan / hapus pesanan dari Firestore
  static Future<void> deleteBooking(String bookingId) async {
    await _bookingsRef.doc(bookingId).delete();
  }
}