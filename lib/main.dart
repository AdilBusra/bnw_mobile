import 'package:flutter/material.dart';
import 'core/admin/admin_store.dart';
import 'core/admin/admin_storage.dart';
import 'core/theme/app_theme.dart';

import 'core/theme/app_theme.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'core/theme/theme.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_login_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/customer/home_screen.dart';
import 'screens/customer/trip_detail_screen.dart';
import 'screens/customer/booking_screen.dart';
import 'screens/customer/upload_payment_screen.dart'; // Import Screen Upload Pembayaran

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BNWMobileApp());
}

class BNWMobileApp extends StatefulWidget {
  const BNWMobileApp({super.key});
  @override
  State<BNWMobileApp> createState() => _BNWMobileAppState();
}
class _BNWMobileAppState extends State<BNWMobileApp> {
  late Future<void> _ready;
  @override
  void initState() { super.initState(); _ready = initializeAdminStorage(AdminStore.instance); }
  @override
  Widget build(BuildContext context) => FutureBuilder<void>(future: _ready, builder: (context, snapshot) {
    if (snapshot.connectionState != ConnectionState.done || snapshot.hasError) {
      return MaterialApp(key: const ValueKey('startup'), debugShowCheckedModeBanner: false, theme: AppTheme.lightTheme,
        home: Scaffold(body: SafeArea(child: Center(child: Padding(padding: const EdgeInsets.all(24),
          child: snapshot.hasError ? Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.storage_outlined, size: 48), const SizedBox(height: 16),
            const Text('Data aplikasi belum dapat dibaca. Data lama tidak ditimpa.', textAlign: TextAlign.center),
            const SizedBox(height: 16), FilledButton(onPressed: () => setState(() {
              _ready = initializeAdminStorage(AdminStore.instance);
            }), child: const Text('Coba Lagi')),
          ]) : const CircularProgressIndicator(),
        )))),
      );
    }
    return MaterialApp(key: const ValueKey('application'), title: 'Beyond & Wanders', debugShowCheckedModeBanner: false,
      theme: IslandClubTheme.theme, initialRoute: '/', routes: {
        '/': (_) => const LoginScreen(), '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(), '/detail': (_) => const TripDetailScreen(),
        '/booking': (_) => const BookingScreen(),
        '/admin-login': (_) => const AdminLoginScreen(),
        '/admin': (_) => Theme(data: AppTheme.lightTheme, child: AdminStore.instance.authenticated
            ? const AdminDashboardScreen() : const AdminLoginScreen()),
      },
    );
  });
}
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
