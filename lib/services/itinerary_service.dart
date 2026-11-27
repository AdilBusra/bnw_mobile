import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/itinerary_model.dart';

class ItineraryService {
  static final CollectionReference<Map<String, dynamic>> _itinerariesRef =
      FirebaseFirestore.instance.collection('itineraries');

  static Stream<List<ItineraryModel>> itinerariesStream(String tripId) {
    return _itinerariesRef.where('tripId', isEqualTo: tripId).snapshots().map((
      snapshot,
    ) {
      final itineraries =
          snapshot.docs
              .map((doc) => ItineraryModel.fromJson(doc.data(), docId: doc.id))
              .toList()
            ..sort((a, b) {
              final dayOrder = a.dayNumber.compareTo(b.dayNumber);
              return dayOrder != 0
                  ? dayOrder
                  : a.timeSlot.compareTo(b.timeSlot);
            });

      return itineraries;
    });
  }

  static Future<void> saveItinerary(ItineraryModel itinerary) {
    return _itinerariesRef.doc(itinerary.id).set(itinerary.toJson());
  }

  static Future<void> deleteItinerary(String tripId, String itineraryId) {
    return _itinerariesRef.doc(itineraryId).delete();
  }
}
