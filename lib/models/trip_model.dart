import 'package:cloud_firestore/cloud_firestore.dart';

class TripModel {
  final String id;
  final String title;
  final String location;
  final String dateRange;
  final double price;
  final int remainingQuota;
  final String category; // 'Private' atau 'Group'
  final String imageUrl;

  TripModel({
    required this.id,
    required this.title,
    required this.location,
    required this.dateRange,
    required this.price,
    required this.remainingQuota,
    required this.category,
    required this.imageUrl,
  });

  // Mengubah dokumen dari Firestore menjadi objek TripModel
  factory TripModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TripModel(
      id: doc.id, // Mengambil ID unik dokumen langsung dari Firestore
      title: data['title'] ?? '',
      location: data['location'] ?? '',
      dateRange: data['dateRange'] ?? '',
      // Menggunakan (.. as num).toDouble() agar aman jika di Firestore tersimpan sebagai int
      price: (data['price'] ?? 0).toDouble(),
      remainingQuota: (data['remainingQuota'] ?? 0).toInt(),
      category: data['category'] ?? 'Group',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // Mengubah objek TripModel menjadi Map untuk dikirim ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'location': location,
      'dateRange': dateRange,
      'price': price,
      'remainingQuota': remainingQuota,
      'category': category,
      'imageUrl': imageUrl,
    };
  }
}