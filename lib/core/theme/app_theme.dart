import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.coconutCream,
      // Mengatur font default seluruh aplikasi menggunakan DM Sans
      textTheme: GoogleFonts.dmSansTextTheme(
        ThemeData.light().textTheme,
      ).copyWith(
        // Mengatur judul menggunakan Fredoka secara otomatis
        displayLarge: GoogleFonts.fredoka(color: AppColors.deepTeal, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.fredoka(color: AppColors.deepTeal, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.fredoka(color: AppColors.deepTeal, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.fredoka(color: AppColors.deepTeal, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.fredoka(color: AppColors.deepTeal, fontWeight: FontWeight.bold),
        headlineSmall: GoogleFonts.fredoka(color: AppColors.deepTeal, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.fredoka(color: AppColors.deepTeal, fontWeight: FontWeight.bold),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.islandPink,
        primary: AppColors.islandPink,
        secondary: AppColors.lagoonAqua,
      ),
    );
  }
}