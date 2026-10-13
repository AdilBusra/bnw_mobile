import 'package:flutter/material.dart';
import '../../core/admin/admin_store.dart';
import '../../widgets/admin/admin_ui.dart';
import 'booking_detail_screen.dart';

class ActiveUsersScreen extends StatefulWidget {
  const ActiveUsersScreen({super.key});
  @override
  State<ActiveUsersScreen> createState() => _ActiveUsersScreenState();
}
class _ActiveUsersScreenState extends State<ActiveUsersScreen> {
  String _query = '';
  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: AdminStore.instance,
    builder: (context, _) {
      final store = AdminStore.instance;
      final users = store.activeUsers.where((u) => '${u.name} ${u.email} ${u.id}'.toLowerCase().contains(_query.trim().toLowerCase())).toList();
      return AdminPage(title: 'Active Users', body: ListView(padding: const EdgeInsets.all(20), children: [
        const Text('Daftar akun customer berstatus aktif.'), const SizedBox(height: 12),
        AdminSearch(hint: 'Cari user atau email', value: _query, onChanged: (v) => setState(() => _query = v)),
        const SizedBox(height: 16),
        if (users.isEmpty) const EmptyState(title: 'User tidak ditemukan', message: 'Coba kata pencarian lainnya.'),
        ...users.map((u) => AdminCard(onTap: () => openAdmin(context, UserTransactionsScreen(userId: u.id)),
            child: Row(children: [const CircleAvatar(child: Icon(Icons.person_outline)), const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(u.name, style: const TextStyle(fontWeight: FontWeight.bold)), Text(u.email),
                Text('${store.bookingsForUser(u.id).length} transaksi'),
              ])), const Icon(Icons.chevron_right)]))),
      ]));
    },
  );
}

class UserTransactionsScreen extends StatelessWidget {
  final String userId;
  const UserTransactionsScreen({super.key, required this.userId});
  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: AdminStore.instance,
    builder: (context, _) {
      final store = AdminStore.instance, user = store.userById(userId);
      final bookings = store.searchBookings('', userId: userId);
      return AdminPage(title: 'Transaksi User', body: ListView(padding: const EdgeInsets.all(20), children: [
        AdminCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(user.name, style: Theme.of(context).textTheme.titleLarge),
          DetailRow('Email', user.email), DetailRow('Telepon', user.phone),
          DetailRow('Status akun', user.active ? 'Active' : 'Inactive'),
        ])),
        const SectionTitle('Riwayat Transaksi'),
        if (bookings.isEmpty) const EmptyState(title: 'Belum ada transaksi', message: 'User ini belum membuat pemesanan.'),
        ...bookings.map((b) => BookingCard(booking: b,
            onTap: () => openAdmin(context, BookingDetailScreen(bookingId: b.id)))),
      ]));
    },
  );
}
