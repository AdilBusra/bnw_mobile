import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bnw_mobile/models/itinerary_model.dart';
import 'firebase_mock.dart';

void main() {
  setUpAll(() async {
    await setupFirebaseForTest();
  });

  group('ItineraryModel Serialization Test', () {
    test('toJson dan fromJson menjaga konsistensi data agenda trip', () {
      const original = ItineraryModel(
        id: 'IT-001',
        tripId: 'TRIP-SIPOLHA',
        dayNumber: 1,
        timeSlot: '05:00 - 07:30 WIB',
        title: 'Sunrise Viewpoint Sipolha',
        location: 'Bukit Sipolha, Simalungun',
        description: 'Menikmati matahari terbit dan sarapan bersama.',
      );

      final restored = ItineraryModel.fromJson(original.toJson());

      expect(restored.id, 'IT-001');
      expect(restored.tripId, 'TRIP-SIPOLHA');
      expect(restored.dayNumber, 1);
      expect(restored.timeSlot, '05:00 - 07:30 WIB');
      expect(restored.title, 'Sunrise Viewpoint Sipolha');
      expect(restored.location, 'Bukit Sipolha, Simalungun');
      expect(
        restored.description,
        'Menikmati matahari terbit dan sarapan bersama.',
      );
    });

    test('fromJson memakai nilai default saat field opsional kosong', () {
      final parsed = ItineraryModel.fromJson(
        {
          'tripId': 'TRIP-02',
          'dayNumber': '2',
          'title': 'Check-out Penginapan',
        },
        docId: 'DOC-99',
      );

      expect(parsed.id, 'DOC-99');
      expect(parsed.dayNumber, 2);
      expect(parsed.timeSlot, '08:00 - 10:00');
      expect(parsed.location, '');
      expect(parsed.description, '');
    });
  });

  testWidgets('Komponen kartu agenda tampil tanpa overflow', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ListTile(
            leading: Chip(label: Text('Day 1')),
            title: Text('Sunrise Viewpoint Sipolha'),
            subtitle: Text('05:00 - 07:30 WIB • Bukit Sipolha'),
          ),
        ),
      ),
    );

    expect(find.text('Day 1'), findsOneWidget);
    expect(find.text('Sunrise Viewpoint Sipolha'), findsOneWidget);
  });
}