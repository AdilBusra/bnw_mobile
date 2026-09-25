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
}

// Data Dummy untuk Uji Coba UI Beranda
final List<TripModel> dummyTrips = [
  TripModel(
    id: '1',
    title: 'Trip 1',
    location: 'Sipolha',
    dateRange: '1 Sept - 4 Sept 2026',
    price: 1500000,
    remainingQuota: 3,
    category: 'Group',
    imageUrl: '',
  ),
  TripModel(
    id: '2',
    title: 'Trip 2',
    location: 'Sipolha',
    dateRange: '1 Okt - 4 Okt 2026',
    price: 1800000,
    remainingQuota: 5,
    category: 'Private',
    imageUrl: '',
  ),
  TripModel(
    id: '3',
    title: 'Trip 3',
    location: 'Sipolha',
    dateRange: '18 Okt - 21 Okt 2026',
    price: 1750000,
    remainingQuota: 1,
    category: 'Group',
    imageUrl: '',
  ),
  TripModel(
    id: '4',
    title: 'Trip 4',
    location: 'Pulau Samosir',
    dateRange: '5 Nov - 8 Nov 2026',
    price: 2100000,
    remainingQuota: 4,
    category: 'Private',
    imageUrl: '',
  ),
  TripModel(
    id: '5',
    title: 'Trip 5',
    location: 'Bukit Holbung',
    dateRange: '12 Nov - 15 Nov 2026',
    price: 1350000,
    remainingQuota: 6,
    category: 'Group',
    imageUrl: '',
  ),
  TripModel(
    id: '6',
    title: 'Trip 6',
    location: 'Tongging Waterfall',
    dateRange: '20 Nov - 23 Nov 2026',
    price: 1600000,
    remainingQuota: 2,
    category: 'Group',
    imageUrl: '',
  ),
];