import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const BNWMobileApp());
}

class BNWMobileApp extends StatelessWidget {
  const BNWMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beyond & Wanders Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto', // Bisa disesuaikan dengan font project kalian
        scaffoldBackgroundColor: const Color(0xFFFEFBEA),
      ),
      home: const SplashScreen(),
    );
  }
}