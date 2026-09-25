import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bnw_mobile/main.dart';
import 'package:bnw_mobile/screens/catalog_screen.dart';
import 'package:bnw_mobile/screens/profile_screen.dart';

void main() {
  testWidgets('Bottom navigation switches between Home, Catalog, and Profile',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BNWMobileApp());
    await tester.pumpAndSettle();

    // Pastikan berada di Home Screen awal
    expect(find.text('Beyond & Wanders Mobile'), findsOneWidget);
    expect(find.text('Explore Your Next Journey'), findsOneWidget);

    // Tap tab Catalog di bottom bar
    await tester.tap(find.byIcon(Icons.storefront_outlined));
    await tester.pumpAndSettle();

    // Pastikan Catalog Screen aktif
    expect(find.text('Trip Catalog'), findsOneWidget);
    expect(find.text('Daftar Paket Wisata'), findsOneWidget);

    // Coba filter pencarian di Catalog
    final searchField = find.byType(TextField).last;
    await tester.enterText(searchField, 'Samosir');
    await tester.pumpAndSettle();
    expect(find.text('Pulau Samosir'), findsOneWidget);

    // Tap tab Profile di bottom bar
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    // Pastikan Profile Screen aktif
    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('Aditya Pratama'), findsOneWidget);
    expect(find.text('Riwayat Pemesanan'), findsOneWidget);

    // Scroll ke tombol Keluar Akun
    await tester.scrollUntilVisible(
      find.text('Keluar Akun'),
      200.0,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Keluar Akun'), findsOneWidget);
  });

  testWidgets('CatalogScreen standalone test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CatalogScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Trip Catalog'), findsOneWidget);
    expect(find.text('Semua'), findsOneWidget);
  });

  testWidgets('ProfileScreen standalone test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('Perjalanan'), findsOneWidget);
  });
}
