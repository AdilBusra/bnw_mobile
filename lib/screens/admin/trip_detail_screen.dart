import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({Key? key}) : super(key: key);

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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.deepTeal),
              title: Text(
                "Trip Detail",
                style: GoogleFonts.fredoka(
                  color: AppColors.deepTeal,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.islandPink),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Buka halaman Edit Trip...')));
                  },
                )
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.deepTeal.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.landscape_rounded, color: AppColors.deepTeal, size: 64),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bali Summer Getaway",
                              style: GoogleFonts.fredoka(fontSize: 24, color: AppColors.deepTeal),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: AppColors.coral),
                                const SizedBox(width: 4),
                                Text("Bali, Indonesia", style: GoogleFonts.plusJakartaSans(color: AppColors.deepTeal)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.lagoonAqua,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          "Active",
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.deepTeal, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildShadowMetricCard("Price", "Rp 2.5jt", Icons.payments_outlined),
                      _buildShadowMetricCard("Quota", "24/30", Icons.group_outlined),
                      _buildShadowMetricCard("Duration", "3 Days", Icons.timer_outlined),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text("Description", style: GoogleFonts.fredoka(fontSize: 18, color: AppColors.deepTeal)),
                  const SizedBox(height: 8),
                  Text(
                    "A beautiful 3-day summer getaway in the heart of Bali. Perfect for those looking to relax on the beach, enjoy tropical drinks, and experience the vibrant island nightlife.",
                    style: GoogleFonts.plusJakartaSans(color: AppColors.deepTeal, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Text("Facilities", style: GoogleFonts.fredoka(fontSize: 18, color: AppColors.deepTeal)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildShadowChip("4-Star Hotel"),
                      _buildShadowChip("Breakfast"),
                      _buildShadowChip("Transport"),
                      _buildShadowChip("Guide"),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text("Requirements", style: GoogleFonts.fredoka(fontSize: 18, color: AppColors.deepTeal)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildShadowChip("Female Only", color: AppColors.softPink),
                      _buildShadowChip("18-35 Years Old", color: AppColors.coconutCream),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ke halaman Itinerary Management...')));
                      },
                      icon: const Icon(Icons.format_list_bulleted_rounded, size: 20),
                      label: Text("Manage Itinerary", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.islandPink,
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShadowMetricCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepTeal.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.islandPink),
            const SizedBox(height: 8),
            Text(value, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.deepTeal)),
            const SizedBox(height: 4),
            Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.greyText)),
          ],
        ),
      ),
    );
  }

  Widget _buildShadowChip(String label, {Color color = Colors.white}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepTeal.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.deepTeal, fontWeight: FontWeight.bold)),
    );
  }
}