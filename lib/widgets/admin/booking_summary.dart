import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/admin/admin_models.dart';
import '../../core/admin/admin_store.dart';
import '../common/trip_facilities.dart';
import 'admin_ui.dart';
import '../../screens/admin/trip_detail_screen.dart';

class BookingSummary extends StatelessWidget {
  final AdminBooking booking;
  const BookingSummary({super.key, required this.booking});
  @override
  Widget build(BuildContext context) {
    final store = AdminStore.instance;
    final user = store.userById(booking.userId), trip = booking.tripSnapshot;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatusBadge(label: booking.paymentStatus.bookingLabel),
      const SectionTitle('Customer & Pemesanan'),
      AdminCard(child: Column(children: [
        DetailRow('Booking ID', booking.id), DetailRow('Customer', user.name),
        DetailRow('Email', user.email), DetailRow('Telepon', user.phone),
        DetailRow('Jumlah peserta', '${booking.participants} orang'),
        DetailRow('Tanggal pesan', dateTimeLabel(booking.bookedAt)),
      ])),
      const SectionTitle('Detail Pembayaran'),
      AdminCard(child: Column(children: [
        DetailRow('Total dibayar', rupiah(booking.amount)),
        DetailRow('Metode', 'Transfer bank'), DetailRow('Rekening tujuan', booking.bankAccount),
        DetailRow('Status pembayaran', booking.paymentStatus.label),
        if (booking.reviewedAt != null) DetailRow('Diproses pada', dateTimeLabel(booking.reviewedAt!)),
        if (booking.reviewNote != null) DetailRow('Catatan', booking.reviewNote!),
      ])),
      PaymentProof(booking: booking),
      const SectionTitle('Detail Trip Saat Pemesanan'),
      AdminCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(trip.name, style: Theme.of(context).textTheme.titleLarge),
        DetailRow('Destinasi', trip.destination), DetailRow('Kategori', trip.category),
        DetailRow('Keberangkatan', dateLabel(trip.startDate)),
        DetailRow('Selesai', dateLabel(trip.endDate)), DetailRow('Durasi', '${trip.durationDays} hari'),
        DetailRow('Harga / peserta', rupiah(trip.price)),
        const SizedBox(height: 12), TripFacilities(selected: trip.facilities),
        const SizedBox(height: 12),
        if (store.tripById(trip.id) != null) TextButton.icon(
            onPressed: () => openAdmin(context, AdminTripDetailScreen(tripId: trip.id)),
            icon: const Icon(Icons.open_in_new), label: const Text('Lihat trip saat ini'))
        else const Text('Trip sudah dihapus. Data riwayat pemesanan tetap tersimpan.'),
      ])),
      const SectionTitle('Riwayat Pesanan'),
      AdminCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        DetailRow('Pesanan dibuat', dateTimeLabel(booking.bookedAt)),
        DetailRow('Pembayaran', booking.paymentStatus == PaymentStatus.pending
            ? 'Menunggu verifikasi admin' : '${booking.paymentStatus.label} • ${dateTimeLabel(booking.reviewedAt ?? booking.bookedAt)}'),
        if (booking.paymentStatus == PaymentStatus.verified) const Text('Pemesanan telah disetujui (Approved).'),
        if (booking.paymentStatus == PaymentStatus.rejected) const Text('Pemesanan ditolak; reservasi kuota sudah dilepas.'),
      ])),
    ]);
  }
}

class PaymentProof extends StatelessWidget {
  final AdminBooking booking;
  const PaymentProof({super.key, required this.booking});
  @override
  Widget build(BuildContext context) {
    final ImageProvider? image = booking.proofBase64 != null
        ? MemoryImage(base64Decode(booking.proofBase64!))
        : booking.proofAsset != null ? AssetImage(booking.proofAsset!) : null;
    return AdminCard(onTap: image == null ? null : () => showDialog<void>(context: context,
      builder: (dialogContext) => Dialog(child: SizedBox(
        height: MediaQuery.sizeOf(dialogContext).height * 0.8,
        child: Column(children: [
          Row(children: [const Expanded(child: Padding(padding: EdgeInsets.all(16), child: Text('Bukti Pembayaran'))),
            IconButton(tooltip: 'Tutup', onPressed: () => Navigator.pop(dialogContext), icon: const Icon(Icons.close))]),
          Expanded(child: InteractiveViewer(child: Image(image: image, fit: BoxFit.contain,
              errorBuilder: (_, error, stack) => const Center(child: Text('Gambar tidak dapat dibuka.'))))),
        ]),
      )),
    ), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Bukti Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 12),
      if (image == null) const Text('Bukti transfer belum tersedia.')
      else Center(child: Image(image: image, height: 170, fit: BoxFit.contain,
          errorBuilder: (_, error, stack) => const Text('Gambar tidak dapat dibuka.'))),
      if (booking.proofAsset != null) const Padding(padding: EdgeInsets.only(top: 12),
          child: Text('Bukti contoh untuk data simulasi; bukan bukti transfer asli.', style: TextStyle(fontSize: 12, color: Colors.black54))),
      if (image != null) const Padding(padding: EdgeInsets.only(top: 8), child: Text('Ketuk untuk memperbesar gambar.')),
    ]));
  }
}
