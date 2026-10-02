import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart'; // Import tema global kita
import 'screens/admin/admin_dashboard_screen.dart'; // Halaman awal Admin Dashboard
import 'core/theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/trip/trip_detail_screen.dart';
import 'screens/trip/booking_screen.dart';

void main() {
  runApp(const BNWMobileApp());
}

class BNWMobileApp extends StatelessWidget {
  const BNWMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beyond & Wanders',
      debugShowCheckedModeBanner: false,
      // 1. Jadikan tema customer sebagai tema global utama
      theme: IslandClubTheme.theme,

      // 2. Gunakan sistem routing dari branch fe_leo
      initialRoute: '/', // Halaman pertama yang dibuka (misal: Login)
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/detail': (context) => const TripDetailScreen(),
        '/booking': (context) => const BookingScreen(),

        // 3. Tambahkan halaman Admin, lalu BUNGKUS dengan tema Admin
        '/admin': (context) => Theme(
          data: AppTheme
              .lightTheme, // Tema khusus ini hanya akan aktif di AdminDashboard
          child: AdminDashboardScreen(),
        ),
      },
    );
  }
}
