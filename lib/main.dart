import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/trip/trip_detail_screen.dart';
import 'screens/trip/booking_screen.dart';

void main() {
  runApp(const IslandClubApp());
}

class IslandClubApp extends StatelessWidget {
  const IslandClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beyond & Wanders',
      debugShowCheckedModeBanner: false,
      theme: IslandClubTheme.theme, // Memanggil tema "Summer Girls"
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/detail': (context) => const TripDetailScreen(),
        '/booking': (context) => const BookingScreen(),// Tambahkan baris ini
      },
    );
  }
}