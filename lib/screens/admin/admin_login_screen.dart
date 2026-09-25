import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/admin/bnw_components.dart';
import 'admin_dashboard_screen.dart'; // Import halaman dashboard ditambahkan di sini

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Gradien simulasi background sunset
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFBE4D8), // Warna langit atas
              Color(0xFFF6C9C4), // Warna sunset tengah
              Color(0xFFE29B96), // Warna laut/bawah
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // TODO: Ganti Container ini dengan Image.asset logo BNW yang asli
                Container(
                  height: 120,
                  width: 120,
                  decoration: const BoxDecoration(
                    color: AppColors.islandPink,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      "LOGO\nBNW",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Judul
                Text(
                  "Beyond & Wanders",
                  style: GoogleFonts.fredoka(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepTeal,
                  ),
                ),
                const SizedBox(height: 8),

                // Subjudul (Admin Version)
                Text(
                  "Admin Portal • Manage your summer club",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppColors.deepTeal,
                  ),
                ),
                const SizedBox(height: 40),

                // Form Input Email
                const BnwTextField(
                  hintText: "Email Address",
                  prefixIcon: Icons.mail_outline_rounded,
                ),

                // Form Input Password
                const BnwTextField(
                  hintText: "Password",
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                ),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.islandPink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Tombol Login (Navigasi Mock ke Dashboard)
                BnwPrimaryButton(
                  text: "Log in",
                  onPressed: () {
                    // Navigasi ke halaman Dashboard
                    Navigator.push(
                      context,
                      // Kata 'const' dihapus dari sini agar tidak error
                      MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Tombol Google (Opsional untuk Admin, tapi disesuaikan dengan desain)
                BnwOutlinedButton(
                  text: "Continue with Google",
                  // Menggunakan ikon bawaan Flutter untuk simulasi logo Google
                  icon: const Icon(Icons.g_mobiledata, color: Colors.blue, size: 32),
                  onPressed: () {},
                ),
                const SizedBox(height: 40),

                // Footer Join Now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Need admin access? ",
                      style: GoogleFonts.plusJakartaSans(color: AppColors.deepTeal),
                    ),
                    Text(
                      "Contact IT",
                      style: GoogleFonts.pacifico( // Font script/latin
                        color: AppColors.deepTeal,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}