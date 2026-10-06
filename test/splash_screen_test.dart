import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bnw_mobile/screens/customer/splash_screen.dart';
import 'package:bnw_mobile/screens/customer/home_screen.dart';

void main() {
  testWidgets('SplashScreen displays logo container, title, and navigates to HomeScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(),
      ),
    );

    // Initial frame: SplashScreen elements
    expect(find.text('Beyond & Wanders'), findsOneWidget);
    expect(find.text('Your Journey Starts Here'), findsOneWidget);
    expect(find.text('Menyiapkan Petualangan...'), findsOneWidget);

    // Advance time past the 2.5s timer and 400ms transition
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    // Verification: Now at HomeScreen
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
