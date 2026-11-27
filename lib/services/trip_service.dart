import 'package:cloud_firestore/cloud_firestore.dart';

typedef TripData = Map<String, dynamic>;

class TripService {
  static final _tripsRef = FirebaseFirestore.instance.collection('trips');

  static Stream<List<TripData>> tripsStream() {
    return _tripsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = TripData.from(doc.data() as Map);
        final start = _parseDate(data['startDate']);
        final end = _parseDate(data['endDate']);

        final rawPrice = data['price'] is num
            ? (data['price'] as num).toInt()
            : int.tryParse(data['price']?.toString() ?? '') ?? 0;

        final rawCapacity = data['capacity'] is num
            ? (data['capacity'] as num).toInt()
            : int.tryParse(data['capacity']?.toString() ?? '') ?? 0;

        final rawFacilities = data['facilities'];
        final facilities = rawFacilities is List
            ? rawFacilities.map((e) => e.toString()).toList()
            : (rawFacilities is String && rawFacilities.isNotEmpty)
                ? rawFacilities.split(',').map((e) => e.trim()).toList()
                : <String>[];

        return TripData.from({
          'id': (data['id'] as String?) ?? doc.id,
          'title': data['name'] ?? 'Untitled Trip',
          'location': data['destination'] ?? '',
          'category': data['category'] ?? 'Group',
          'price': _formatRupiah(rawPrice),
          'rawPrice': rawPrice,
          'rating': (data['rating'] ?? '4.9').toString(),
          'image': data['imageAsset'] ?? 'assets/images/nature.jfif',
          'imageBase64': data['imageBase64'],
          'date': _formatDateRange(start, end),
          'description': data['description'] ?? '',
          'facilities': facilities,
          'capacity': rawCapacity,
        });
      }).toList();
    });
  }

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  static String _formatRupiah(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return 'Rp $buffer';
  }

  static String _formatDateRange(DateTime start, DateTime end) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final startText = '${start.day} ${months[start.month - 1]} ${start.year}';
    if (start.year == end.year && start.month == end.month && start.day == end.day) {
      return startText;
    }
    if (start.year == end.year && start.month == end.month) {
      return '${start.day} - ${end.day} ${months[end.month - 1]} ${end.year}';
    }
    return '${start.day} ${months[start.month - 1]} - ${end.day} ${months[end.month - 1]} ${end.year}';
  }
}