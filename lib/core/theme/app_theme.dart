import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.dmSansTextTheme(
      ThemeData.light().textTheme,
    ).apply(
      bodyColor: AppColors.deepTeal,
      displayColor: AppColors.deepTeal,
    ).copyWith(
      displayLarge: GoogleFonts.fredoka(
        color: AppColors.deepTeal,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.fredoka(
        color: AppColors.deepTeal,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.fredoka(
        color: AppColors.deepTeal,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: GoogleFonts.fredoka(
        color: AppColors.deepTeal,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.fredoka(
        color: AppColors.deepTeal,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: GoogleFonts.fredoka(
        color: AppColors.deepTeal,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.fredoka(
        color: AppColors.deepTeal,
        fontWeight: FontWeight.bold,
      ),
    );

    const inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide.none,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.coconutCream,
      canvasColor: AppColors.coconutCream,
      primaryColor: AppColors.islandPink,
      dividerColor: AppColors.sand,
      textTheme: textTheme,
      iconTheme: const IconThemeData(
        color: AppColors.deepTeal,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.islandPink,
      ).copyWith(
        primary: AppColors.islandPink,
        onPrimary: AppColors.white,
        secondary: AppColors.lagoonAqua,
        onSecondary: AppColors.deepTeal,
        secondaryContainer: AppColors.seafoam,
        onSecondaryContainer: AppColors.deepTeal,
        tertiary: AppColors.sunshine,
        onTertiary: AppColors.deepTeal,
        surface: AppColors.white,
        onSurface: AppColors.deepTeal,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.coconutCream,
        surfaceTintColor: AppColors.coconutCream,
        foregroundColor: AppColors.deepTeal,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.deepTeal,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        indicatorColor: AppColors.lagoonAqua,
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            color: AppColors.deepTeal,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(color: AppColors.deepTeal),
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0,
      ),
      badgeTheme: const BadgeThemeData(
        backgroundColor: AppColors.sunshine,
        textColor: AppColors.deepTeal,
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: AppColors.white,
        selectedColor: AppColors.lagoonAqua,
        secondarySelectedColor: AppColors.lagoonAqua,
        labelStyle: TextStyle(color: AppColors.deepTeal),
        secondaryLabelStyle: TextStyle(color: AppColors.deepTeal),
        checkmarkColor: AppColors.deepTeal,
        side: BorderSide.none,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        labelStyle: TextStyle(color: AppColors.deepTeal),
        hintStyle: TextStyle(color: AppColors.deepTeal),
        errorStyle: TextStyle(color: AppColors.deepTeal),
        prefixIconColor: AppColors.deepTeal,
        suffixIconColor: AppColors.deepTeal,
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder,
        errorBorder: inputBorder,
        focusedErrorBorder: inputBorder,
        disabledBorder: inputBorder,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          minimumSize: const Size(48, 52),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.islandPink,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          minimumSize: const Size(48, 52),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.deepTeal,
          side: const BorderSide(color: AppColors.lagoonAqua),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          minimumSize: const Size(48, 52),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.deepTeal,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.islandPink,
        foregroundColor: AppColors.white,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.islandPink,
        linearTrackColor: AppColors.seafoam,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.deepTeal,
        contentTextStyle: TextStyle(color: AppColors.white),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
      ),
      datePickerTheme: const DatePickerThemeData(
        backgroundColor: AppColors.coconutCream,
        headerBackgroundColor: AppColors.lagoonAqua,
        headerForegroundColor: AppColors.deepTeal,
        surfaceTintColor: AppColors.coconutCream,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.deepTeal,
        selectionColor: AppColors.seafoam,
        selectionHandleColor: AppColors.lagoonAqua,
      ),
    );
  }
}