import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../models/payment_model.dart';
import '../../services/booking_service.dart';
import '../../services/trip_service.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  ({String assetPath, String? base64Str}) _resolveTripMedia(
    BookingModel booking,
    List<TripData> trips,
  ) {
    TripData? matched;
    for (final t in trips) {
      if (booking.tripId.isNotEmpty && t['id'] == booking.tripId) {
        matched = t;
        break;
      }
    }
    matched ??= trips.cast<TripData?>().firstWhere(
          (t) =>
              t != null &&
              (t['title'] ?? '').toString().toLowerCase() ==
                  booking.tripTitle.toLowerCase(),
          orElse: () => null,
        );

    final base64Str = (booking.tripImageBase64?.trim().isNotEmpty ?? false)
        ? booking.tripImageBase64
        : matched?['imageBase64'] as String?;

    final assetPath = (matched?['image'] as String?)?.isNotEmpty == true
        ? matched!['image'] as String
        : booking.tripImageAsset;

    return (assetPath: assetPath, base64Str: base64Str);
  }

  Widget _buildTripImage(
    String assetPath, {
    String? base64Str,
    double width = 80,
    double height = 80,
  }) {
    if (base64Str != null && base64Str.trim().isNotEmpty) {
      try {
        final cleaned = base64Str.contains(',')
            ? base64Str.split(',').last.trim()
            : base64Str.trim();
        return Image.memory(
          base64Decode(cleaned),
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Image.asset(
            assetPath.isNotEmpty ? assetPath : 'assets/images/nature.jfif',
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        );
      } catch (_) {}
    }

    return Image.asset(
      assetPath.isNotEmpty ? assetPath : 'assets/images/nature.jfif',
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/nature.jfif',
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildProofPreview(String? rawBase64) {
    if (rawBase64 == null || rawBase64.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    try {
      final cleaned = rawBase64.contains(',')
          ? rawBase64.split(',').last.trim()
          : rawBase64.trim();
      final bytes = base64Decode(cleaned);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text(
            'Bukti Transfer Terunggah',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(
              bytes,
              width: double.infinity,
              height: 140,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Text(
                'Preview bukti tidak tersedia',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),
        ],
      );
    } catch (_) {
      return const SizedBox.shrink();
    }
  }

  void _openReupload(BookingModel booking, {String? base64Str}) {
    final tripArg = Map<String, dynamic>.from(booking.tripSnapshot);
    tripArg['title'] = booking.tripTitle;
    tripArg['location'] = booking.tripLocation;
    tripArg['image'] = booking.tripImageAsset;
    if (base64Str != null) {
      tripArg['imageBase64'] = base64Str;
    }

    Navigator.pushNamed(
      context,
      '/upload_payment',
      arguments: {
        'reuploadBookingId': booking.id,
        'trip': tripArg,
        'participants': booking.participants,
        'tripCategory': booking.tripCategory,
        'formattedTotal': BookingService.formatRupiah(booking.amount),
      },
    );
  }

  Future<void> _confirmCancelBooking(BookingModel booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Batalkan Pesanan?',
          style: TextStyle(color: Color(0xFF164C55), fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Pesanan ${booking.tripTitle} (${booking.id}) akan dihapus dari daftar booking.',
          style: const TextStyle(color: Color(0xFF164C55)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Tidak', style: TextStyle(color: Color(0xFF164C55))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ya, Batalkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await BookingService.deleteBooking(booking.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan berhasil dibatalkan.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membatalkan pesanan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // POPUP REVIEW
  void _showReviewDialog(BuildContext context, String title) {
    int rating = 5;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: const Text(
                'Rate Your Trip 🌟',
                style: TextStyle(color: Color(0xFF164C55), fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'How was your experience at $title?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF164C55)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                          color: const Color(0xFFFFC857),
                          size: 32,
                        ),
                        onPressed: () {
                          setDialogState(() {
                            rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Share your thoughts...',
                      filled: true,
                      fillColor: const Color(0xFFFFF7DF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Color(0xFF164C55))),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5427D),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thank you for your review! 🌺')),
                    );
                  },
                  child: const Text('Submit', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // POPUP DETAIL BOOKING HASIL PEMESANAN
  void _showBookingDetailDialog(
    BuildContext context,
    BookingModel booking, {
    required String assetPath,
    String? base64Str,
  }) {
    final formattedPrice = BookingService.formatRupiah(booking.amount);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.confirmation_num_rounded, color: Color(0xFFF5427D)),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Booking Details',
                style: TextStyle(
                  color: Color(0xFF164C55),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _buildTripImage(
                    assetPath,
                    base64Str: base64Str,
                    width: 140,
                    height: 95,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                booking.tripTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF164C55),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                booking.tripLocation,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Divider(height: 24, color: Color(0xFFFFD1DC)),
              _detailRow('Booking ID', booking.id),
              _detailRow('Status', booking.paymentStatus.ticketLabel),
              _detailRow('Pemesan', booking.customerName),
              _detailRow('Trip Date', booking.selectedDate.isNotEmpty ? booking.selectedDate : '-'),
              _detailRow('Trip Type', booking.tripCategory),
              _detailRow('Participants', '${booking.participants} Person'),
              _detailRow('Total Price', formattedPrice),
              if (booking.paymentStatus == BookingPaymentStatus.rejected &&
                  (booking.reviewNote?.trim().isNotEmpty ?? false)) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Catatan Admin: ${booking.reviewNote}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              _buildProofPreview(booking.proofBase64),
            ],
          ),
        ),
        actions: [
          if (booking.paymentStatus == BookingPaymentStatus.pending)
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _confirmCancelBooking(booking);
              },
              child: const Text('Batalkan', style: TextStyle(color: Colors.red)),
            ),
          if (booking.paymentStatus == BookingPaymentStatus.rejected)
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _openReupload(booking, base64Str: base64Str);
              },
              child: const Text(
                'Upload Ulang',
                style: TextStyle(color: Color(0xFFF5427D), fontWeight: FontWeight.bold),
              ),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5427D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF164C55),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusBgColor(BookingPaymentStatus status) => switch (status) {
        BookingPaymentStatus.verified => const Color(0xFF4CAF50).withOpacity(0.18),
        BookingPaymentStatus.rejected => Colors.red.withOpacity(0.15),
        BookingPaymentStatus.pending => const Color(0xFFFFC857).withOpacity(0.25),
      };

  Color _statusTextColor(BookingPaymentStatus status) => switch (status) {
        BookingPaymentStatus.verified => const Color(0xFF2E7D32),
        BookingPaymentStatus.rejected => Colors.red.shade700,
        BookingPaymentStatus.pending => const Color(0xFF856404),
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF7DF), Color(0xFFFFD1DC)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('My Tickets', style: theme.textTheme.displayMedium),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.confirmation_num_rounded, color: Color(0xFFF5427D)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: currentUid == null
                    ? Center(
                        child: Text(
                          'Silakan login untuk melihat tiket kamu.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF164C55).withOpacity(0.7),
                          ),
                        ),
                      )
                    : StreamBuilder<List<TripData>>(
                        stream: TripService.tripsStream(),
                        builder: (context, tripsSnapshot) {
                          final trips = tripsSnapshot.data ?? const <TripData>[];

                          return StreamBuilder<List<BookingModel>>(
                            stream: BookingService.customerBookingsStream(currentUid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(color: Color(0xFFF5427D)),
                                );
                              }

                              if (snapshot.hasError) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Text(
                                      'Gagal memuat tiket:\n${snapshot.error}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                              }

                              final tickets = snapshot.data ?? [];

                              if (tickets.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No tickets booked yet, bestie!',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: const Color(0xFF164C55).withOpacity(0.6),
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                itemCount: tickets.length,
                                itemBuilder: (context, index) {
                                  final booking = tickets[index];
                                  final media = _resolveTripMedia(booking, trips);
                                  final isVerified = booking.paymentStatus == BookingPaymentStatus.verified;
                                  final isRejected = booking.paymentStatus == BookingPaymentStatus.rejected;
                                  final formattedPrice = BookingService.formatRupiah(booking.amount);

                                  return GestureDetector(
                                    onTap: () => _showBookingDetailDialog(
                                      context,
                                      booking,
                                      assetPath: media.assetPath,
                                      base64Str: media.base64Str,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 20.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.06),
                                            blurRadius: 15,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(16),
                                                  child: _buildTripImage(
                                                    media.assetPath,
                                                    base64Str: media.base64Str,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              booking.tripTitle,
                                                              style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                            decoration: BoxDecoration(
                                                              color: _statusBgColor(booking.paymentStatus),
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            child: Text(
                                                              booking.paymentStatus.label,
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.bold,
                                                                color: _statusTextColor(booking.paymentStatus),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        booking.tripLocation,
                                                        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.calendar_today_rounded,
                                                            size: 14,
                                                            color: Color(0xFFF5427D),
                                                          ),
                                                          const SizedBox(width: 4),
                                                          Expanded(
                                                            child: Text(
                                                              booking.selectedDate.isNotEmpty
                                                                  ? booking.selectedDate
                                                                  : 'Jadwal fleksibel',
                                                              style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.bold,
                                                                color: Color(0xFF164C55),
                                                              ),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (isRejected && (booking.reviewNote?.trim().isNotEmpty ?? false))
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                                              child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.red.withOpacity(0.08),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  'Alasan ditolak: ${booking.reviewNote}',
                                                  style: const TextStyle(fontSize: 11, color: Colors.red),
                                                ),
                                              ),
                                            ),
                                          const Divider(height: 1, color: Color(0xFFFFD1DC)),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${booking.tripCategory} • ${booking.participants} Person',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: const Color(0xFF164C55).withOpacity(0.7),
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                if (isVerified)
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color(0xFFF5427D),
                                                      minimumSize: Size.zero,
                                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                    ),
                                                    onPressed: () => _showReviewDialog(context, booking.tripTitle),
                                                    child: const Text(
                                                      'Review',
                                                      style: TextStyle(fontSize: 12, color: Colors.white),
                                                    ),
                                                  )
                                                else if (isRejected)
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color(0xFFF5427D),
                                                      minimumSize: Size.zero,
                                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                    ),
                                                    onPressed: () => _openReupload(booking, base64Str: media.base64Str),
                                                    child: const Text(
                                                      'Upload Ulang',
                                                      style: TextStyle(fontSize: 12, color: Colors.white),
                                                    ),
                                                  )
                                                else
                                                  Text(
                                                    formattedPrice,
                                                    style: theme.textTheme.displayMedium?.copyWith(
                                                      color: const Color(0xFFF5427D),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}