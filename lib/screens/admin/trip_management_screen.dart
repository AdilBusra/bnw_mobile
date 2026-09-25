import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'add_edit_trip_screen.dart';
import 'trip_detail_screen.dart';

class TripManagementScreen extends StatelessWidget {
  const TripManagementScreen({Key? key}) : super(key: key);

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
              automaticallyImplyLeading: false, // Menghilangkan tanda panah kembali (back button)
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                "Trip Management",
                style: GoogleFonts.fredoka(
                  color: AppColors.deepTeal,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddEditTripScreen(isEditing: false)),
                      );
                    },
                    icon: const Icon(Icons.add, size: 16),
                    label: Text("Add Trip", style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.islandPink,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      elevation: 3,
                    ),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
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
                            const Icon(Icons.search, color: AppColors.greyText),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search trip name or destination...",
                                  hintStyle: GoogleFonts.dmSans(color: AppColors.greyText),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip("All Trips", true),
                            const SizedBox(width: 8),
                            _buildFilterChip("Active", false),
                            const SizedBox(width: 8),
                            _buildFilterChip("Draft", false),
                            const SizedBox(width: 8),
                            _buildFilterChip("Full Quota", false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    children: [
                      _buildAdminTripCard(
                        context,
                        "Bali Summer Getaway",
                        "Bali, Indonesia",
                        "12 Aug - 15 Aug 2026",
                        "Rp 2.500.000",
                        "24/30",
                        "Active",
                      ),
                      _buildAdminTripCard(
                        context,
                        "Nusa Penida Day Trip",
                        "Nusa Penida, Bali",
                        "20 Aug 2026",
                        "Rp 850.000",
                        "30/30",
                        "Full",
                      ),
                      _buildAdminTripCard(
                        context,
                        "Lombok Surf Camp",
                        "Lombok, NTB",
                        "01 Sep - 05 Sep 2026",
                        "Rp 3.200.000",
                        "0/15",
                        "Draft",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.lagoonAqua : Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepTeal.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.deepTeal,
        ),
      ),
    );
  }

  Widget _buildAdminTripCard(
      BuildContext context,
      String title,
      String location,
      String date,
      String price,
      String quota,
      String status,
      ) {
    Color statusColor;
    if (status == "Active") {
      statusColor = AppColors.lagoonAqua;
    } else if (status == "Full") {
      statusColor = AppColors.coral;
    } else {
      statusColor = AppColors.coconutCream;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepTeal.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.coconutCream,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.landscape_rounded, color: AppColors.deepTeal, size: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.deepTeal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status,
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepTeal,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: AppColors.coral),
                        const SizedBox(width: 4),
                        Text(location, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.deepTeal)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, size: 14, color: AppColors.islandPink),
                        const SizedBox(width: 4),
                        Text(date, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.deepTeal)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(price, style: GoogleFonts.fredoka(color: AppColors.islandPink, fontSize: 14)),
                        Text("Quota: $quota", style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.deepTeal)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.deepTeal.withValues(alpha: 0.1), thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TripDetailScreen()),
                  );
                },
                icon: const Icon(Icons.visibility_outlined, color: AppColors.deepTeal, size: 18),
                label: Text("View", style: GoogleFonts.dmSans(color: AppColors.deepTeal, fontWeight: FontWeight.bold)),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddEditTripScreen(isEditing: true)),
                  );
                },
                icon: const Icon(Icons.edit_outlined, color: AppColors.deepTeal, size: 18),
                label: Text("Edit", style: GoogleFonts.dmSans(color: AppColors.deepTeal, fontWeight: FontWeight.bold)),
              ),
              TextButton.icon(
                onPressed: () => _showDeleteDialog(context),
                icon: const Icon(Icons.delete_outline, color: AppColors.coral, size: 18),
                label: Text("Delete", style: GoogleFonts.dmSans(color: AppColors.coral, fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text("Delete Trip?", style: GoogleFonts.fredoka(color: AppColors.deepTeal)),
        content: Text("Are you sure you want to delete this trip? This action cannot be undone.", style: GoogleFonts.dmSans(color: AppColors.deepTeal)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.dmSans(color: AppColors.greyText, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Simulasi: Trip berhasil dihapus!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.coral,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            ),
            child: Text("Delete", style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}