import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'payment_verification_screen.dart'; // Import halaman verifikasi pembayaran

class BookingListScreen extends StatelessWidget {
  const BookingListScreen({super.key});

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
                "Booking List",
                style: GoogleFonts.fredoka(
                  color: AppColors.deepTeal,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Column(
              children: [
                // SEARCH & FILTER
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
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
                              hintText: "Search customer or booking ID...",
                              hintStyle: GoogleFonts.plusJakartaSans(color: AppColors.greyText),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // DAFTAR BOOKING
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    children: [
                      _buildBookingCard(context, "BK-9921", "Sarah Jenkins", "Bali Summer Getaway", "Rp 2.500.000", "Pending Verify"),
                      _buildBookingCard(context, "BK-9920", "Jessica Alba", "Lombok Surf Camp", "Rp 3.200.000", "Confirmed"),
                      _buildBookingCard(context, "BK-9919", "Amanda Smith", "Nusa Penida Trip", "Rp 850.000", "Confirmed"),
                      _buildBookingCard(context, "BK-9918", "Chloe Grace", "Bali Summer Getaway", "Rp 2.500.000", "Cancelled"),
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

  Widget _buildBookingCard(BuildContext context, String id, String name, String trip, String price, String status) {
    Color statusColor;
    if (status == "Confirmed") {
      statusColor = AppColors.lagoonAqua;
    } else if (status == "Pending Verify") {
      statusColor = AppColors.sunshine;
    } else {
      statusColor = AppColors.coral;
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
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                id,
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.greyText),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.deepTeal),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.deepTeal),
          ),
          const SizedBox(height: 2),
          Text(
            trip,
            style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.greyText),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: GoogleFonts.fredoka(fontSize: 15, color: AppColors.islandPink),
              ),
              TextButton(
                onPressed: () {
                  // Tombol kini aktif: mengarah ke halaman verifikasi atau dialog detail
                  if (status == "Pending Verify") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PaymentVerificationScreen()),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: Text("Booking Details ($id)", style: GoogleFonts.fredoka(color: AppColors.deepTeal)),
                        content: Text(
                          "Customer: $name\nTrip: $trip\nTotal: $price\nStatus: $status",
                          style: GoogleFonts.plusJakartaSans(color: AppColors.deepTeal, height: 1.5),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Close", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.islandPink)),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text(
                  "View Detail",
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.deepTeal),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}