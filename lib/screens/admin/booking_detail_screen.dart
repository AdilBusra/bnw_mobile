import 'package:flutter/material.dart';
import '../../core/admin/admin_models.dart';
import '../../core/admin/admin_store.dart';
import '../../widgets/admin/admin_ui.dart';
import '../../widgets/admin/booking_summary.dart';
import 'payment_verification_screen.dart';

class BookingDetailScreen extends StatelessWidget {
  final String bookingId;
  const BookingDetailScreen({super.key, required this.bookingId});
  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: AdminStore.instance,
    builder: (context, _) {
      final booking = AdminStore.instance.bookingById(bookingId);
      return AdminPage(title: 'Booking Detail', body: booking == null
          ? const EmptyState(title: 'Pesanan tidak ditemukan', message: 'Kembali ke daftar pemesanan.')
          : ListView(padding: const EdgeInsets.all(20), children: [
        BookingSummary(booking: booking),
        if (booking.paymentStatus == PaymentStatus.pending) FilledButton.icon(
            onPressed: () => openAdmin(context, PaymentDetailScreen(bookingId: booking.id)),
            icon: const Icon(Icons.verified_outlined), label: const Text('Verifikasi Pembayaran')),
        const SizedBox(height: 24),
      ]),
      );
    },
  );
}
