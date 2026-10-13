import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'core/theme/theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/customer/home_screen.dart';
import 'screens/customer/trip_detail_screen.dart';
import 'screens/customer/booking_screen.dart';
import 'screens/customer/upload_payment_screen.dart'; // Import Screen Upload Pembayaran

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
      theme: IslandClubTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/detail': (context) => const TripDetailScreen(),
        '/booking': (context) => const BookingScreen(),
        '/upload_payment': (context) => const UploadPaymentScreen(), // Daftarkan Rute Disini

        '/admin': (context) => Theme(
          data: AppTheme.lightTheme,
          child: AdminDashboardScreen(),
        ),
      },
    );
  }
}