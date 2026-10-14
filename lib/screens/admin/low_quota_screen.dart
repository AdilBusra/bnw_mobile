import 'package:flutter/material.dart';
import '../../core/admin/admin_store.dart';
import '../../widgets/admin/admin_ui.dart';
import 'trip_detail_screen.dart';

class LowQuotaScreen extends StatelessWidget {
  const LowQuotaScreen({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: AdminStore.instance,
    builder: (context, _) {
      final trips = AdminStore.instance.lowQuotaTrips;
      return AdminPage(title: 'Low Quota', body: ListView(padding: const EdgeInsets.all(20), children: [
        const Text('Trip aktif dengan sisa kuota 0–3 kursi. Pesanan pending dan approved sudah menghitung reservasi kursi.'),
        const SizedBox(height: 18),
        if (trips.isEmpty) const EmptyState(title: 'Kuota masih tersedia', message: 'Tidak ada trip dengan kuota rendah.'),
        ...trips.map((t) => TripListCard(trip: t,
            onTap: () => openAdmin(context, AdminTripDetailScreen(tripId: t.id)))),
      ]));
    },
  );
}
