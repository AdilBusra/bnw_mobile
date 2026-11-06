import 'package:flutter/material.dart';
import 'core/admin/admin_store.dart';
import 'core/admin/admin_storage.dart';
import 'core/theme/app_theme.dart';

import 'screens/admin/admin_dashboard_screen.dart';
import 'core/theme/theme.dart';
import 'screens/admin/admin_login_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/customer/home_screen.dart';
import 'screens/customer/trip_detail_screen.dart';
import 'screens/customer/booking_screen.dart';
import 'screens/customer/upload_payment_screen.dart'; 

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  void initState() { 
    super.initState(); 
    _ready = initializeAdminStorage(AdminStore.instance); 
  }
  
  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
    future: _ready, 
    builder: (context, snapshot) {
      // Menunggu admin storage siap (tidak ada yang diubah di sini)
      if (snapshot.connectionState != ConnectionState.done || snapshot.hasError) {
        return MaterialApp(
          key: const ValueKey('startup'), 
          debugShowCheckedModeBanner: false, 
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: snapshot.hasError 
                    ? Column(
                        mainAxisSize: MainAxisSize.min, 
                        children: [
                          const Icon(Icons.storage_outlined, size: 48), 
                          const SizedBox(height: 16),
                          const Text('Data aplikasi belum dapat dibaca. Data lama tidak ditimpa.', textAlign: TextAlign.center),
                          const SizedBox(height: 16), 
                          FilledButton(
                            onPressed: () => setState(() {
                              _ready = initializeAdminStorage(AdminStore.instance);
                            }), 
                            child: const Text('Coba Lagi')
                          ),
                        ]
                      ) 
                    : const CircularProgressIndicator(),
                )
              )
            )
          ),
        );
      }
      
      // Aplikasi Utama
      return MaterialApp(
        key: const ValueKey('application'), 
        title: 'Beyond & Wanders', 
        debugShowCheckedModeBanner: false,
        theme: IslandClubTheme.theme, 
        
        // 1. MENGGANTI initialRoute DENGAN HOME STREAMBUILDER
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnapshot) {
            // Jika status loading memori internal hp
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            
            // Jika user punya sesi login aktif, langsung ke HomeScreen
            if (authSnapshot.hasData) {
              return const HomeScreen();
            }
            
            // Jika belum punya akun / belum login, masuk ke LoginScreen
            return const LoginScreen();
          },
        ),

        // 2. MENGHAPUS rute '/' AGAR TIDAK BENTROK DENGAN PROPERTI 'home'
        routes: {
          '/register': (_) => const RegisterScreen(),
          '/home': (_) => const HomeScreen(), 
          '/detail': (_) => const TripDetailScreen(),
          '/booking': (_) => const BookingScreen(),
          '/upload_payment': (_) => const UploadPaymentScreen(),
          '/admin-login': (_) => const AdminLoginScreen(),
          '/admin': (_) => Theme(
            data: AppTheme.lightTheme, 
            child: AdminStore.instance.authenticated
                ? const AdminDashboardScreen() : const AdminLoginScreen()
          ),
        },
      );
    }
  );
}