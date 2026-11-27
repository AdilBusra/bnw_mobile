import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/admin/admin_models.dart';
import '../../core/admin/admin_store.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/admin/admin_ui.dart';
import 'booking_detail_screen.dart';

class ParticipantManifestScreen extends StatefulWidget {
  final String? initialTripId;

  const ParticipantManifestScreen({super.key, this.initialTripId});

  @override
  State<ParticipantManifestScreen> createState() =>
      _ParticipantManifestScreenState();
}

class _ParticipantManifestScreenState extends State<ParticipantManifestScreen> {
  String? _selectedTripId;
  bool _verifiedOnly = true;

  @override
  void initState() {
    super.initState();
    _selectedTripId = widget.initialTripId;
  }

  void _copyManifest(
    BuildContext context,
    AdminTrip trip,
    List<AdminBooking> entries,
    AdminStore store,
  ) {
    if (entries.isEmpty) {
      notice(context, 'Belum ada peserta untuk disalin.');
      return;
    }

    final buffer = StringBuffer()
      ..writeln('MANIFEST PESERTA - ${trip.name.toUpperCase()}')
      ..writeln('Destinasi: ${trip.destination}')
      ..writeln(
        'Jadwal: ${dateLabel(trip.startDate)} - ${dateLabel(trip.endDate)}',
      )
      ..writeln('----------------------------------------');

    var totalPax = 0;
    for (var i = 0; i < entries.length; i++) {
      final b = entries[i];
      final user = store.userById(b.userId);
      totalPax += b.participants;
      buffer.writeln(
        '${i + 1}. ${user.name} (${b.participants} pax) | HP: ${user.phone} | ${b.paymentStatus.label} [${b.id}]',
      );
    }

    buffer
      ..writeln('----------------------------------------')
      ..writeln('Total Peserta: $totalPax / ${trip.capacity} kuota');

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    notice(context, 'Manifest peserta berhasil disalin ke clipboard.');
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AdminStore.instance,
      builder: (context, _) {
        final store = AdminStore.instance;
        final trips = store.trips;

        if (trips.isEmpty) {
          return const AdminPage(
            title: 'Participant Manifest',
            body: EmptyState(
              title: 'Belum ada trip',
              message: 'Tambahkan trip terlebih dahulu untuk melihat manifest.',
            ),
          );
        }

        final activeTrip = (_selectedTripId != null
                ? store.tripById(_selectedTripId!)
                : null) ??
            trips.first;

        final tripBookings = store.bookings
            .where(
              (b) =>
                  b.tripId == activeTrip.id &&
                  b.paymentStatus != PaymentStatus.rejected,
            )
            .toList()
          ..sort((a, b) => a.bookedAt.compareTo(b.bookedAt));

        final verifiedBookings = tripBookings
            .where((b) => b.paymentStatus == PaymentStatus.verified)
            .toList();

        final displayedBookings =
            _verifiedOnly ? verifiedBookings : tripBookings;

        final verifiedPax =
            verifiedBookings.fold(0, (sum, b) => sum + b.participants);
        final pendingPax = tripBookings
            .where((b) => b.paymentStatus == PaymentStatus.pending)
            .fold(0, (sum, b) => sum + b.participants);

        return AdminPage(
          title: 'Participant Manifest',
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SectionTitle('Pilih Trip'),
              DropdownButtonFormField<String>(
                value: activeTrip.id,
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                items: trips
                    .map(
                      (t) => DropdownMenuItem<String>(
                        value: t.id,
                        child: Text(
                          '${t.name} (${dateLabel(t.startDate)})',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedTripId = value);
                  }
                },
              ),
              const SectionTitle('Ringkasan Keberangkatan'),
              AdminCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            activeTrip.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        StatusBadge(
                          label: activeTrip.completedAt(store.clock())
                              ? 'Selesai'
                              : 'Active',
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(activeTrip.destination),
                    const Divider(height: 20),
                    DetailRow(
                      'Tanggal Trip',
                      '${dateLabel(activeTrip.startDate)} - ${dateLabel(activeTrip.endDate)}',
                    ),
                    DetailRow('Kategori', activeTrip.category),
                    DetailRow(
                      'Peserta Terverifikasi',
                      '$verifiedPax / ${activeTrip.capacity} pax',
                    ),
                    DetailRow('Menunggu Verifikasi', '$pendingPax pax'),
                    DetailRow(
                      'Sisa Kuota',
                      '${store.remainingQuota(activeTrip)} kursi',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: Text('Verified ($verifiedPax)'),
                          selected: _verifiedOnly,
                          onSelected: (_) =>
                              setState(() => _verifiedOnly = true),
                        ),
                        ChoiceChip(
                          label: Text(
                            'Semua (${verifiedPax + pendingPax})',
                          ),
                          selected: !_verifiedOnly,
                          onSelected: (_) =>
                              setState(() => _verifiedOnly = false),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => _copyManifest(
                      context,
                      activeTrip,
                      displayedBookings,
                      store,
                    ),
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: const Text('Salin'),
                  ),
                ],
              ),
              const SectionTitle('Daftar Peserta'),
              if (displayedBookings.isEmpty)
                EmptyState(
                  title: _verifiedOnly
                      ? 'Belum ada peserta terverifikasi'
                      : 'Belum ada peserta terdaftar',
                  message: _verifiedOnly
                      ? 'Verifikasi bukti transfer customer agar peserta masuk ke manifest keberangkatan.'
                      : 'Pesanan yang masuk untuk trip ini akan tampil di sini.',
                )
              else
                ...List.generate(displayedBookings.length, (index) {
                  final booking = displayedBookings[index];
                  final user = store.userById(booking.userId);

                  return AdminCard(
                    onTap: () => openAdmin(
                      context,
                      BookingDetailScreen(bookingId: booking.id),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.softPink,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.islandPink,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '${booking.id} • ${booking.participants} Peserta',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge(label: booking.paymentStatus.label),
                          ],
                        ),
                        const Divider(height: 18),
                        DetailRow('WhatsApp / HP', user.phone),
                        DetailRow('Email', user.email),
                        DetailRow('Total Bayar', rupiah(booking.amount)),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}