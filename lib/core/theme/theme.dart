import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IslandClubTheme {
  // Core Palette
  static const Color islandPink = Color(0xFFF5427D);
  static const Color lagoonAqua = Color(0xFF65D5D5);
  static const Color coconutCream = Color(0xFFFFF7DF);
  static const Color sunshineYellow = Color(0xFFFFC857);
  static const Color deepTeal = Color(0xFF164C55);

  // Secondary Accents
  static const Color coral = Color(0xFFFF8066);
  static const Color softPink = Color(0xFFFFD1DC);

  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: coconutCream,
      primaryColor: islandPink,
      colorScheme: const ColorScheme.light(
        primary: islandPink,
        secondary: lagoonAqua,
        tertiary: sunshineYellow,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSurface: deepTeal,
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: GoogleFonts.fredoka(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: deepTeal,
          height: 1.1,
        ),
        displayMedium: GoogleFonts.fredoka(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: deepTeal,
        ),
        titleLarge: GoogleFonts.fredoka(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: islandPink,
        ),
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: deepTeal,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: deepTeal,
        ),
        // Handwriting accent for small labels or decorative text
        labelMedium: GoogleFonts.caveat(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: coral,
        ),
      ),

      // Buttons (Pill-shaped, flat, chunky text)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: islandPink,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: GoogleFonts.fredoka(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: deepTeal,
          backgroundColor: coconutCream,
          side: const BorderSide(color: lagoonAqua, width: 3),
          textStyle: GoogleFonts.fredoka(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),

      // Cards (Large organic curves, outlined playfully)
      cardTheme: CardThemeData( // <-- Ubah di sini
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: const BorderSide(color: softPink, width: 2),
        ),
      ),

      // Inputs (Completely rounded, bubbly borders on focus)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: softPink, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: softPink, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: lagoonAqua, width: 3),
        ),
        hintStyle: GoogleFonts.dmSans(color: deepTeal.withOpacity(0.4)),
      ),
    );
  }
}