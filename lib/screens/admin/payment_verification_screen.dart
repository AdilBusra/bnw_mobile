import 'package:flutter/material.dart';
import '../../core/admin/admin_models.dart';
import '../../core/admin/admin_store.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/admin/admin_ui.dart';
import '../../widgets/admin/booking_summary.dart';
import 'booking_detail_screen.dart';

class PaymentVerificationScreen extends StatefulWidget {
  final String title;
  const PaymentVerificationScreen({super.key, this.title = 'Payment Verification'});
  @override
  State<PaymentVerificationScreen> createState() => _PaymentVerificationScreenState();
}
class _PaymentVerificationScreenState extends State<PaymentVerificationScreen> {
  String _query = '';
  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: AdminStore.instance,
    builder: (context, _) => DefaultTabController(length: 3,
      child: AdminPage(title: widget.title, body: Column(children: [
        Padding(padding: const EdgeInsets.all(16), child: AdminSearch(hint: 'Cari customer, ID atau nama trip', value: _query,
            onChanged: (v) => setState(() => _query = v))),
        const TabBar(isScrollable: true, tabAlignment: TabAlignment.start,
            tabs: [Tab(text: 'Need Verify'), Tab(text: 'Verified'), Tab(text: 'Rejected')]),
        Expanded(child: TabBarView(children: PaymentStatus.values.map((status) {
          final bookings = AdminStore.instance.searchBookings(_query, status: status);
          return ListView(padding: const EdgeInsets.all(20), children: [
            Text('${bookings.length} pembayaran • ${status.label}'), const SizedBox(height: 16),
            if (bookings.isEmpty) const EmptyState(title: 'Tidak ada pembayaran', message: 'Daftar ini akan menampilkan pembayaran sesuai status dan pencarian.'),
            ...bookings.map((b) => BookingCard(booking: b,
                onTap: () => openAdmin(context, PaymentDetailScreen(bookingId: b.id)))),
            const SizedBox(height: 16),
          ]);
        }).toList())),
      ])),
    ),
  );
}

class PaymentDetailScreen extends StatefulWidget {
  final String bookingId;
  const PaymentDetailScreen({super.key, required this.bookingId});
  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}
class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  bool _saving = false;
  Future<void> _review(PaymentStatus status) async {
    String? note;
    if (status == PaymentStatus.rejected) {
      note = await showDialog<String>(context: context,
          builder: (_) => const _RejectPaymentDialog());
      if (note == null) return;
    } else {
      if (!await confirmAction(context, title: 'Approve pembayaran?',
          message: 'Pastikan nominal dan bukti pembayaran sudah sesuai. Pesanan ini akan menjadi Approved.', confirmLabel: 'Approve')) return;
    }
    if (!mounted) return;
    setState(() => _saving = true);
    try {
      await AdminStore.instance.reviewPayment(widget.bookingId, status, note: note);
      if (!mounted) return;
      notice(context, status == PaymentStatus.verified ? 'Pembayaran berhasil diverifikasi.' : 'Pembayaran ditolak; kuota diperbarui.');
    } catch (error) {
      if (mounted) notice(context, friendlyError(error));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: AdminStore.instance,
    builder: (context, _) {
      final booking = AdminStore.instance.bookingById(widget.bookingId);
      return AdminPage(title: 'Detail Pembayaran', body: booking == null
          ? const EmptyState(title: 'Pembayaran tidak ditemukan', message: 'Kembali ke daftar pembayaran.')
          : ListView(padding: const EdgeInsets.all(20), children: [
        BookingSummary(booking: booking),
        if (booking.paymentStatus == PaymentStatus.pending) ...[
          if (_saving) const LinearProgressIndicator(),
          const SizedBox(height: 12),
          // Wrap allows buttons and their labels to grow at large text sizes.
          Wrap(spacing: 12, runSpacing: 12, children: [
            OutlinedButton.icon(onPressed: _saving ? null : () => _review(PaymentStatus.rejected),
                icon: const Icon(Icons.close), label: const Text('Reject')),
            FilledButton.icon(onPressed: _saving ? null : () => _review(PaymentStatus.verified),
                style: FilledButton.styleFrom(backgroundColor: AppColors.lagoonAqua, foregroundColor: AppColors.deepTeal),
                icon: const Icon(Icons.check), label: const Text('Approve')),
          ]),
        ] else TextButton.icon(onPressed: () => openAdmin(context, BookingDetailScreen(bookingId: booking.id)),
            icon: const Icon(Icons.receipt_long_outlined), label: const Text('Lihat Booking Detail')),
        const SizedBox(height: 32),
      ]),
      );
    },
  );
}

class _RejectPaymentDialog extends StatefulWidget {
  const _RejectPaymentDialog();
  @override
  State<_RejectPaymentDialog> createState() => _RejectPaymentDialogState();
}
class _RejectPaymentDialogState extends State<_RejectPaymentDialog> {
  final _controller = TextEditingController();
  final _key = GlobalKey<FormState>();
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Tolak pembayaran'),
    content: SingleChildScrollView(child: Form(key: _key, child: TextFormField(
        controller: _controller, maxLines: 3,
        decoration: const InputDecoration(labelText: 'Alasan penolakan'),
        validator: (v) => v == null || v.trim().isEmpty ? 'Alasan wajib diisi' : null))),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      FilledButton(onPressed: () {
        if (_key.currentState!.validate()) Navigator.pop(context, _controller.text.trim());
      }, child: const Text('Reject')),
    ],
  );
}
