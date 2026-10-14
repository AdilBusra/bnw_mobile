import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../core/admin/admin_models.dart';
import '../../core/admin/admin_store.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../screens/admin/admin_profile_screen.dart';
import '../../screens/admin/notifications_screen.dart';

String rupiah(num value) => NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(value);
String dateLabel(DateTime value) => DateFormat('dd MMM yyyy').format(value);
String dateTimeLabel(DateTime value) => DateFormat('dd MMM yyyy, HH:mm').format(value);

Future<T?> openAdmin<T>(BuildContext context, Widget screen) => Navigator.of(context).push<T>(
  MaterialPageRoute(builder: (_) => Theme(data: AppTheme.lightTheme, child: screen)),
);
void notice(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
String friendlyError(Object error) {
  if (error is ArgumentError) return error.message?.toString() ?? 'Periksa data yang diisi.';
  if (error is StateError) return error.message;
  return 'Data belum berhasil disimpan. Coba lagi dan periksa ruang penyimpanan perangkat.';
}
Future<bool> confirmAction(BuildContext context, {required String title, required String message,
  String confirmLabel = 'Konfirmasi'}) async => await showDialog<bool>(
  context: context, builder: (dialogContext) => AlertDialog(
  title: Text(title), content: Text(message), actions: [
  TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
  FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: Text(confirmLabel)),
],
),
) ?? false;

Future<String?> pickPhoto() async {
  final file = await ImagePicker().pickImage(source: ImageSource.gallery,
      maxWidth: 1200, maxHeight: 1200, imageQuality: 80);
  if (file == null) return null;
  final bytes = await file.readAsBytes();
  if (bytes.length > 2 * 1024 * 1024) throw ArgumentError('Pilih gambar berukuran maksimal 2 MB.');
  return base64Encode(bytes);
}
ImageProvider tripImage(AdminTrip trip) => trip.imageBase64 == null
    ? AssetImage(trip.imageAsset) : MemoryImage(base64Decode(trip.imageBase64!));

class AdminAvatar extends StatelessWidget {
  final double radius;
  const AdminAvatar({super.key, this.radius = 18});
  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: AdminStore.instance,
    builder: (context, _) {
      final photo = AdminStore.instance.profile.photoBase64;
      return CircleAvatar(radius: radius, backgroundColor: AppColors.lagoonAqua,
        backgroundImage: photo == null ? null : MemoryImage(base64Decode(photo)),
        child: photo == null ? Icon(Icons.person_rounded, size: radius + 6, color: AppColors.deepTeal) : null,
      );
    },
  );
}

class AdminBackground extends StatelessWidget {
  final Widget child;

  const AdminBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.coconutCream,
            AppColors.softPink,
            AppColors.softPink,
            AppColors.coconutCream,
          ],
          stops: [0.0, 0.35, 0.70, 1.0],
        ),
      ),
      child: child,
    );
  }
}

class AdminPage extends StatelessWidget {
  final String title;
  final Widget body;
  final bool embedded;
  final Widget? floatingActionButton;

  const AdminPage({
    super.key,
    required this.title,
    required this.body,
    this.embedded = false,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: AdminBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            foregroundColor: AppColors.deepTeal,
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: !embedded,
            title: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              ListenableBuilder(
                listenable: AdminStore.instance,
                builder: (context, _) {
                  final count =
                      AdminStore.instance.pendingPayments.length;

                  return IconButton(
                    tooltip: 'Notifikasi',
                    onPressed: () => openAdmin(
                      context,
                      const NotificationsScreen(),
                    ),
                    icon: Badge(
                      backgroundColor: AppColors.islandPink,
                      textColor: AppColors.white,
                      isLabelVisible: count > 0,
                      label: Text('$count'),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: AppColors.deepTeal,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                tooltip: 'Admin Profile',
                onPressed: () => openAdmin(
                  context,
                  const AdminProfileScreen(),
                ),
                icon: const AdminAvatar(),
              ),
              const SizedBox(width: 6),
            ],
          ),
          body: SafeArea(
            top: false,
            child: body,
          ),
          floatingActionButton: floatingActionButton,
        ),
      ),
    );
  }
}

class AdminCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  const AdminCard({super.key, required this.child, this.onTap,
    this.padding = const EdgeInsets.all(18)});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Material(color: Colors.white, borderRadius: BorderRadius.circular(20),
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(20),
          child: Padding(padding: padding, child: child)),
    ),
  );
}

class EmptyState extends StatelessWidget {
  final String title, message;
  final IconData icon;
  const EmptyState({super.key, required this.title, required this.message, this.icon = Icons.inbox_outlined});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 48, color: AppColors.deepTeal), const SizedBox(height: 14),
      Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8), Text(message, textAlign: TextAlign.center),
    ]),
  );
}

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const StatusBadge({super.key, required this.label, this.color = AppColors.lagoonAqua});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(9)),
    child: Text(label, style: const TextStyle(color: AppColors.deepTeal, fontWeight: FontWeight.bold, fontSize: 12)),
  );
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(top: 10, bottom: 12),
      child: Text(text, style: Theme.of(context).textTheme.titleLarge));
}

class DetailRow extends StatelessWidget {
  final String label, value;
  const DetailRow(this.label, this.value, {super.key});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 8),
    child: LayoutBuilder(builder: (context, constraints) {
      final labelWidget = Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13));
      final valueWidget = Text(value, style: const TextStyle(fontWeight: FontWeight.w600));
      if (constraints.maxWidth < 280 || MediaQuery.textScalerOf(context).scale(1) > 1.3) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [labelWidget, const SizedBox(height: 4), valueWidget]);
      }
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 2, child: labelWidget), const SizedBox(width: 12),
        Expanded(flex: 3, child: valueWidget),
      ]);
    }),
  );
}

class AdminSearch extends StatelessWidget {
  final String hint;
  final String value;
  final ValueChanged<String> onChanged;
  const AdminSearch({super.key, required this.hint, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) => TextFormField(initialValue: value, onChanged: onChanged,
      decoration: InputDecoration(hintText: hint, prefixIcon: const Icon(Icons.search)));
}

class BookingCard extends StatelessWidget {
  final AdminBooking booking;
  final VoidCallback onTap;
  const BookingCard({super.key, required this.booking, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final user = AdminStore.instance.userById(booking.userId);
    return AdminCard(onTap: onTap, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const CircleAvatar(backgroundColor: AppColors.coconutCream,
          child: Icon(Icons.receipt_long_rounded, color: AppColors.deepTeal)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4), Text(booking.tripSnapshot.name),
        const SizedBox(height: 6), Text('${booking.id} • ${booking.participants} peserta',
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 8), Wrap(spacing: 12, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center,
            children: [Text(rupiah(booking.amount), style: const TextStyle(fontWeight: FontWeight.bold)),
              StatusBadge(label: booking.paymentStatus.bookingLabel,
                  color: switch (booking.paymentStatus) {
                    PaymentStatus.pending => AppColors.sunshine,
                    PaymentStatus.verified => AppColors.lagoonAqua,
                    PaymentStatus.rejected => AppColors.coral,
                  })]),
      ])),
      const Icon(Icons.chevron_right),
    ]));
  }
}

class TripListCard extends StatelessWidget {
  final AdminTrip trip;
  final VoidCallback onTap;
  const TripListCard({super.key, required this.trip, required this.onTap});
  @override
  Widget build(BuildContext context) => AdminCard(onTap: onTap,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(borderRadius: BorderRadius.circular(12), child: Image(image: tripImage(trip),
            width: 64, height: 80, fit: BoxFit.cover,
            errorBuilder: (_, error, stack) => const SizedBox(width: 64, height: 80, child: Icon(Icons.landscape)))),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(trip.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4), Text(trip.destination),
          const SizedBox(height: 4), Text('${dateLabel(trip.startDate)} – ${dateLabel(trip.endDate)}',
              style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 8), Wrap(spacing: 8, runSpacing: 6, children: [
            StatusBadge(label: trip.completedAt(AdminStore.instance.clock()) ? 'Selesai' : 'Active'),
            StatusBadge(label: '${AdminStore.instance.remainingQuota(trip)} / ${trip.capacity} kursi', color: AppColors.sunshine),
          ]),
          const SizedBox(height: 6), Text(rupiah(trip.price), style: const TextStyle(fontWeight: FontWeight.bold)),
        ])),
        const Icon(Icons.chevron_right),
      ]));
}
