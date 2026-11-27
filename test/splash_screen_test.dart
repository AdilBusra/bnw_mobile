import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bnw_mobile/screens/customer/splash_screen.dart';
import 'firebase_mock.dart';

void main() {
  setUpAll(() async {
    await setupFirebaseForTest();
  });

  testWidgets('SplashScreen menampilkan identitas aplikasi saat dibuka',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SplashScreen(),
      ),
    );

    expect(find.text('Beyond & Wanders'), findsOneWidget);
    expect(find.text('Your Journey Starts Here'), findsOneWidget);
    expect(find.text('Menyiapkan Petualangan...'), findsOneWidget);

    // Lepas widget sebelum timer navigasi ke stream Firestore berjalan
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 3));
  });
}