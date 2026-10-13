import 'package:flutter/material.dart';
import '../../core/admin/admin_models.dart';
import '../../core/admin/admin_store.dart';
import '../../widgets/admin/admin_ui.dart';
import 'booking_detail_screen.dart';

class BookingListScreen extends StatefulWidget {
  final bool embedded;
  final String? userId;
  const BookingListScreen({super.key, this.embedded = false, this.userId});
  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}
class _BookingListScreenState extends State<BookingListScreen> {
  String _query = '';
  PaymentStatus? _status;
  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: AdminStore.instance,
    builder: (context, _) {
      final bookings = AdminStore.instance.searchBookings(_query, userId: widget.userId, status: _status);
      return AdminPage(title: 'Booking List', embedded: widget.embedded,
        body: ListView(padding: const EdgeInsets.all(20), children: [
          AdminSearch(hint: 'Cari customer, ID, trip, atau status', value: _query,
              onChanged: (v) => setState(() => _query = v)),
          const SizedBox(height: 14), Wrap(spacing: 8, runSpacing: 8, children: [
            ChoiceChip(label: const Text('All'), selected: _status == null,
                onSelected: (_) => setState(() => _status = null)),
            ...PaymentStatus.values.map((s) => ChoiceChip(label: Text(s.bookingLabel), selected: _status == s,
                onSelected: (_) => setState(() => _status = s))),
          ]),
          const SizedBox(height: 16), Text('${bookings.length} pemesanan'), const SizedBox(height: 12),
          if (bookings.isEmpty) const EmptyState(title: 'Pesanan tidak ditemukan', message: 'Coba pencarian atau status lainnya.'),
          ...bookings.map((b) => BookingCard(booking: b,
              onTap: () => openAdmin(context, BookingDetailScreen(bookingId: b.id)))),
        ]),
      );
    },
  );
}
