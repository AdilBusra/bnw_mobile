import 'package:flutter/material.dart';
import '../../core/admin/admin_store.dart';
import '../../widgets/admin/admin_ui.dart';
import '../../widgets/common/trip_facilities.dart';
import 'add_edit_trip_screen.dart';

class AdminTripDetailScreen extends StatefulWidget {
  final String tripId;
  const AdminTripDetailScreen({super.key, required this.tripId});
  @override
  State<AdminTripDetailScreen> createState() => _AdminTripDetailScreenState();
}
class _AdminTripDetailScreenState extends State<AdminTripDetailScreen> {
  bool _deleting = false;
  Future<void> _delete() async {
    if (!await confirmAction(context, title: 'Delete trip?',
        message: 'Trip dihapus dari daftar. Riwayat pemesanan customer tetap tersimpan. Tindakan ini tidak bisa dibatalkan.',
        confirmLabel: 'Delete')) return;
    if (!mounted) return;
    setState(() => _deleting = true);
    try {
      await AdminStore.instance.deleteTrip(widget.tripId);
      if (!mounted) return;
      notice(context, 'Trip berhasil dihapus.');
      Navigator.pop(context);
    } catch (error) {
      if (mounted) notice(context, friendlyError(error));
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }
  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: AdminStore.instance,
    builder: (context, _) {
      final store = AdminStore.instance, trip = store.tripById(widget.tripId);
      return AdminPage(title: 'Trip Detail', body: trip == null
          ? const EmptyState(title: 'Trip sudah dihapus', message: 'Kembali ke daftar trip.')
          : ListView(padding: const EdgeInsets.all(20), children: [
        ClipRRect(borderRadius: BorderRadius.circular(24), child: Image(image: tripImage(trip),
            height: 200, width: double.infinity, fit: BoxFit.cover,
            errorBuilder: (_, error, stack) => const SizedBox(height: 160, child: Icon(Icons.landscape, size: 50)))),
        const SizedBox(height: 20), Text(trip.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6), Text(trip.destination), const SizedBox(height: 12),
        StatusBadge(label: trip.completedAt(store.clock()) ? 'Selesai' : 'Active'),
        const SectionTitle('Jadwal & Kuota'),
        AdminCard(child: Column(children: [
          DetailRow('Keberangkatan', dateLabel(trip.startDate)), DetailRow('Selesai', dateLabel(trip.endDate)),
          DetailRow('Durasi', '${trip.durationDays} hari'), DetailRow('Kategori', trip.category),
          DetailRow('Harga / peserta', rupiah(trip.price)),
          DetailRow('Total kuota', '${trip.capacity} peserta'),
          DetailRow('Kursi terreservasi', '${store.reservedSeats(trip.id)} peserta'),
          DetailRow('Sisa kuota', '${store.remainingQuota(trip)} peserta'),
        ])),
        const SectionTitle('Deskripsi'), Text(trip.description),
        const SectionTitle("What's included"), TripFacilities(selected: trip.facilities),
        const SizedBox(height: 30),
        if (_deleting) const LinearProgressIndicator(),
        Wrap(spacing: 12, runSpacing: 12, children: [
          FilledButton.icon(onPressed: _deleting ? null : () => openAdmin(context, AddEditTripScreen(tripId: trip.id)),
              icon: const Icon(Icons.edit_outlined), label: const Text('Edit Trip')),
          OutlinedButton.icon(onPressed: _deleting ? null : _delete,
              icon: const Icon(Icons.delete_outline), label: const Text('Delete Trip')),
        ]),
        const SizedBox(height: 28),
      ]),
      );
    },
  );
}
