import 'package:flutter/material.dart';
import '../../core/admin/admin_store.dart';
import '../../widgets/admin/admin_ui.dart';
import 'add_edit_trip_screen.dart';
import 'trip_detail_screen.dart';

class TripManagementScreen extends StatefulWidget {
  final bool embedded;
  const TripManagementScreen({super.key, this.embedded = false});
  @override
  State<TripManagementScreen> createState() => _TripManagementScreenState();
}
class _TripManagementScreenState extends State<TripManagementScreen> {
  String _query = '', _filter = 'All';
  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: AdminStore.instance,
    builder: (context, _) {
      final trips = AdminStore.instance.searchTrips(_query, filter: _filter);
      return AdminPage(title: 'Trip Management', embedded: widget.embedded,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => openAdmin(context, const AddEditTripScreen()),
            icon: const Icon(Icons.add), label: const Text('Add Trip')),
        body: ListView(padding: const EdgeInsets.fromLTRB(20, 12, 20, 100), children: [
          AdminSearch(hint: 'Cari nama, lokasi, kategori, atau ID', value: _query,
              onChanged: (v) => setState(() => _query = v)),
          const SizedBox(height: 14),
          Wrap(spacing: 8, runSpacing: 6, children: ['All', 'Active', 'Selesai'].map((f) => ChoiceChip(
              label: Text(f), selected: f == _filter,
              onSelected: (_) => setState(() => _filter = f))).toList()),
          const SizedBox(height: 16), Text('${trips.length} trip ditemukan'), const SizedBox(height: 12),
          if (trips.isEmpty) const EmptyState(title: 'Trip tidak ditemukan', message: 'Coba kata pencarian atau kategori lainnya.'),
          ...trips.map((t) => TripListCard(trip: t,
              onTap: () => openAdmin(context, AdminTripDetailScreen(tripId: t.id)))),
        ]),
      );
    },
  );
}
