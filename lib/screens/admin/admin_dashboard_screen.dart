import 'package:flutter/material.dart';
import '../../core/admin/admin_models.dart';
import '../../core/admin/admin_store.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/admin/admin_ui.dart';
import 'trip_management_screen.dart';
import 'booking_list_screen.dart';
import 'admin_profile_screen.dart';
import 'add_edit_trip_screen.dart';
import 'booking_detail_screen.dart';
import 'payment_verification_screen.dart';
import 'active_users_screen.dart';
import 'need_verify_screen.dart';
import 'low_quota_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          AdminHomeTabContent(),
          TripManagementScreen(embedded: true),
          BookingListScreen(embedded: true),
          AdminProfileScreen(embedded: true),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.softPink,
        elevation: 0,
        selectedIndex: _index,
        onDestinationSelected: (value) {
          setState(() => _index = value);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home,
              color: AppColors.islandPink,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(
              Icons.calendar_month,
              color: AppColors.islandPink,
            ),
            label: 'Trips',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(
              Icons.receipt_long,
              color: AppColors.islandPink,
            ),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(
              Icons.person,
              color: AppColors.islandPink,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class AdminHomeTabContent extends StatelessWidget {
  const AdminHomeTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AdminStore.instance,
      builder: (context, _) {
        final store = AdminStore.instance;
        final recent = store.searchBookings('').take(5).toList();

        return AdminPage(
          title: 'Admin Portal',
          embedded: true,
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Halo, ${store.profile.name}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              const Text('Manage your summer club journey'),
              const SectionTitle('Overview Statistics'),
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth < 300 ||
                      MediaQuery.textScalerOf(context).scale(1) > 1.4
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 12) / 2;

                  return Wrap(
                    spacing: 12,
                    children: [
                      _stat(
                        context,
                        width,
                        'Total Booking',
                        store.bookings.length,
                        Icons.book_online_rounded,
                        AppColors.islandPink,
                        const BookingListScreen(),
                      ),
                      _stat(
                        context,
                        width,
                        'Active Users',
                        store.activeUsers.length,
                        Icons.groups_rounded,
                        AppColors.lagoonAqua,
                        const ActiveUsersScreen(),
                      ),
                      _stat(
                        context,
                        width,
                        'Need Verify',
                        store.pendingPayments.length,
                        Icons.receipt_long_rounded,
                        AppColors.sunshine,
                        const NeedVerifyScreen(),
                      ),
                      _stat(
                        context,
                        width,
                        'Low Quota',
                        store.lowQuotaTrips.length,
                        Icons.warning_rounded,
                        AppColors.coral,
                        const LowQuotaScreen(),
                      ),
                    ],
                  );
                },
              ),
              const SectionTitle('Quick Actions'),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  FilledButton.icon(
                    onPressed: () => openAdmin(
                      context,
                      const AddEditTripScreen(),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Trip'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => openAdmin(
                      context,
                      const PaymentVerificationScreen(),
                    ),
                    icon: const Icon(Icons.verified_outlined),
                    label: const Text('Verify Payments'),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const SectionTitle('Recent Bookings'),
              if (recent.isEmpty)
                const EmptyState(
                  title: 'Belum ada pemesanan',
                  message: 'Pesanan akan muncul di sini.',
                ),
              ...recent.map(
                    (b) => BookingCard(
                  booking: b,
                  onTap: () => openAdmin(
                    context,
                    b.paymentStatus == PaymentStatus.pending
                        ? PaymentDetailScreen(bookingId: b.id)
                        : BookingDetailScreen(bookingId: b.id),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _stat(
      BuildContext context,
      double width,
      String label,
      int count,
      IconData icon,
      Color color,
      Widget destination,
      ) {
    return SizedBox(
      width: width,
      child: AdminCard(
        onTap: () => openAdmin(context, destination),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.2),
                  child: Icon(icon, color: color),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}