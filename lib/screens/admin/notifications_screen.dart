import 'package:flutter/material.dart';
import '../../core/admin/admin_store.dart';
import '../../widgets/admin/admin_ui.dart';
import 'payment_verification_screen.dart';
import 'trip_detail_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: AdminStore.instance,
    builder: (context, _) {
      final store = AdminStore.instance;
      return AdminPage(title: 'Notifikasi', body: ListView(padding: const EdgeInsets.all(20), children: [
        const Text('Notifikasi mengikuti pembayaran pending dan trip dengan kuota rendah.'),
        const SectionTitle('Pembayaran Butuh Verifikasi'),
        if (store.pendingPayments.isEmpty) const Text('Semua pembayaran telah diproses.'),
        ...store.pendingPayments.map((b) => BookingCard(booking: b,
            onTap: () => openAdmin(context, PaymentDetailScreen(bookingId: b.id)))),
        const SectionTitle('Kuota Trip'),
        if (store.lowQuotaTrips.isEmpty) const Text('Tidak ada peringatan kuota.'),
        ...store.lowQuotaTrips.map((t) => TripListCard(trip: t,
            onTap: () => openAdmin(context, AdminTripDetailScreen(tripId: t.id)))),
      ]));
    },
  );
}
