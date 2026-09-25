import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'trip_management_screen.dart';
import 'booking_list_screen.dart';
import 'payment_verification_screen.dart';
import 'add_edit_trip_screen.dart';
import 'admin_profile_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  // Daftar halaman utama yang terhubung langsung dengan Bottom Navigation Bar
  // Tanpa menghilangkan menu bawah dan tanpa tombol back panah atas
  final List<Widget> _pages = [
    const AdminHomeTabContent(),      // Halaman 0: Home / Dashboard
    const TripManagementScreen(),     // Halaman 1: Trips
    const BookingListScreen(),        // Halaman 2: Bookings
    const AdminProfileScreen(),       // Halaman 3: Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.coconutCream,
              AppColors.softPink,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            // Menggunakan IndexedStack agar state halaman tetap terjaga dan BottomBar tidak hilang
            body: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepTeal.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index; // Berpindah tab tanpa menghilangkan menu bawah
                  });
                },
                backgroundColor: Colors.transparent,
                selectedItemColor: AppColors.islandPink,
                unselectedItemColor: AppColors.deepTeal.withValues(alpha: 0.6),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                elevation: 0,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
                  BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: "Trips"),
                  BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: "Bookings"),
                  BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget terpisah khusus untuk isi konten Tab Home/Dashboard (Tanpa tombol Back di AppBar)
class AdminHomeTabContent extends StatelessWidget {
  const AdminHomeTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan tombol back secara otomatis
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Admin Portal",
              style: GoogleFonts.fredoka(
                color: AppColors.islandPink,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Manage your summer club journey",
              style: GoogleFonts.dmSans(
                color: AppColors.deepTeal,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                // Bisa diarahkan ke tab profil (index 3) jika diklik
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.islandPink.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: AppColors.softPink,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SEARCH BAR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepTeal.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.deepTeal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search bookings or trips...",
                        hintStyle: GoogleFonts.dmSans(color: AppColors.greyText),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune, color: AppColors.deepTeal, size: 18),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            const SizedBox(height: 28),

            Text(
              "Overview Statistics",
              style: GoogleFonts.fredoka(
                fontSize: 18,
                color: AppColors.deepTeal,
              ),
            ),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              children: [
                _buildShadowStatCard(context, "Total Booking", "128", AppColors.islandPink, Icons.book_online_rounded, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingListScreen()));
                }),
                _buildShadowStatCard(context, "Active Users", "342", AppColors.lagoonAqua, Icons.groups_rounded, () {}),
                _buildShadowStatCard(context, "Need Verify", "14", AppColors.sunshine, Icons.receipt_long_rounded, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentVerificationScreen()));
                }),
                _buildShadowStatCard(context, "Low Quota", "3", AppColors.coral, Icons.warning_rounded, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TripManagementScreen()));
                }),
              ],
            ),
            const SizedBox(height: 32),

            Text(
              "Quick Actions",
              style: GoogleFonts.fredoka(
                fontSize: 18,
                color: AppColors.deepTeal,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.2,
              children: [
                _buildQuickActionCard(context, "Add Trip", AppColors.islandPink, Icons.add_circle_outline_rounded, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditTripScreen(isEditing: false)));
                }),
                _buildQuickActionCard(context, "Verify Payments", AppColors.lagoonAqua, Icons.verified_rounded, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentVerificationScreen()));
                }),
                _buildQuickActionCard(context, "View Bookings", AppColors.sunshine, Icons.list_alt_rounded, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingListScreen()));
                }),
                _buildQuickActionCard(context, "Trip Manager", AppColors.coral, Icons.card_travel_rounded, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TripManagementScreen()));
                }),
              ],
            ),
            const SizedBox(height: 32),

            Text(
              "Recent Bookings",
              style: GoogleFonts.fredoka(
                fontSize: 18,
                color: AppColors.deepTeal,
              ),
            ),
            const SizedBox(height: 16),
            _buildShadowBookingCard(context, "BK-9921", "Sarah Jenkins", "Bali Getaway", "Rp 1.500.000,-", true),
            _buildShadowBookingCard(context, "BK-9920", "Jessica Alba", "Lombok Surf", "Rp 2.100.000,-", false),
            _buildShadowBookingCard(context, "BK-9919", "Amanda Smith", "Nusa Penida", "Rp 1.800.000,-", false),
          ],
        ),
      ),
    );
  }

  Widget _buildShadowStatCard(BuildContext context, String title, String value, Color color, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: GoogleFonts.fredoka(
                    fontSize: 26,
                    height: 1.0,
                    color: AppColors.deepTeal,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            Text(
              title,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.deepTeal.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, String title, Color color, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepTeal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShadowBookingCard(BuildContext context, String id, String name, String trip, String price, bool isPending) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepTeal.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.coconutCream,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.flight_takeoff_rounded, color: AppColors.deepTeal),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: AppColors.deepTeal, fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  trip,
                  style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.greyText),
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: GoogleFonts.fredoka(fontSize: 13, color: AppColors.islandPink),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                id,
                style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.greyText, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  if (isPending) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentVerificationScreen()));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingListScreen()));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPending ? AppColors.sunshine.withValues(alpha: 0.3) : AppColors.lagoonAqua.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isPending ? "Verify" : "Detail",
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepTeal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}