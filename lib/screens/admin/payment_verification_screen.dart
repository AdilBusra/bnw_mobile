import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class PaymentVerificationScreen extends StatelessWidget {
  const PaymentVerificationScreen({super.key});

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
                "Payment Verification",
                style: GoogleFonts.fredoka(
                  color: AppColors.deepTeal,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CARD BUKTI TRANSFER
                  Container(
                    width: double.infinity,
                    height: 220,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.receipt_long_rounded, color: AppColors.islandPink, size: 56),
                        const SizedBox(height: 8),
                        Text(
                          "Slip Transfer / Bukti Bayar",
                          style: GoogleFonts.plusJakartaSans(color: AppColors.deepTeal, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Tap to preview image",
                          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.greyText),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // DETAIL TRANSAKSI
                  Text("Transaction Details", style: GoogleFonts.fredoka(fontSize: 18, color: AppColors.deepTeal)),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(20),
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
                    child: Column(
                      children: [
                        _buildDetailRow("Booking ID", "BK-9921"),
                        _buildDetailRow("Customer Name", "Sarah Jenkins"),
                        _buildDetailRow("Trip Package", "Bali Summer Getaway"),
                        _buildDetailRow("Amount Paid", "Rp 2.500.000"),
                        _buildDetailRow("Bank Account", "BCA - 1234567890"),
                        _buildDetailRow("Status", "Pending Review"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // TOMBOL AKSI (REJECT & APPROVE)
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Pembayaran ditolak.')),
                              );
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.coral,
                              side: const BorderSide(color: AppColors.coral, width: 1.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                            ),
                            child: Text("Reject", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Pembayaran berhasil diverifikasi!')),
                              );
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.lagoonAqua,
                              foregroundColor: AppColors.deepTeal,
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                            ),
                            child: Text("Approve", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        // Diperbaiki menjadi spaceBetween yang benar
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.plusJakartaSans(color: AppColors.greyText, fontSize: 13)),
          Text(value, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.deepTeal, fontSize: 13)),
        ],
      ),
    );
  }
}