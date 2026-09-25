import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart'; // Import tema global kita
import 'screens/admin/admin_dashboard_screen.dart'; // Halaman awal Admin Dashboard

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
      // Menerapkan tema global (termasuk font Fredoka & DM Sans)
      theme: AppTheme.lightTheme,
      // Halaman pertama yang dibuka
      home: AdminDashboardScreen(),
    );
  }
}