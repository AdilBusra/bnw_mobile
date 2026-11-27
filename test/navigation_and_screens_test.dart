import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bnw_mobile/screens/auth/login_screen.dart';
import 'package:bnw_mobile/screens/auth/register_screen.dart';
import 'package:bnw_mobile/screens/customer/home_screen.dart';
import 'firebase_mock.dart';

void main() {
  setUpAll(() async {
    await setupFirebaseForTest();
  });

  testWidgets('LoginScreen merender form email, password, dan tombol masuk',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(TextFormField), findsAtLeastNWidgets(2));
    expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
  });

  testWidgets('RegisterScreen merender form pendaftaran akun baru',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(TextFormField), findsAtLeastNWidgets(3));
  });

  testWidgets('BottomNavigationBar berpindah antar tab customer',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Popular Escapes'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_border_rounded));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Saved Escapes'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.confirmation_num_outlined));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('My Tickets'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('My Profile'), findsOneWidget);
  });
}