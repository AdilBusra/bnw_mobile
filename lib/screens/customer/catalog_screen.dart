import 'package:flutter/material.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> allDestinations = [
    {
      'title': 'Sipolha Peak Sunrise',
      'location': 'Sipolha, Simalungun',
      'category': 'Open Trip',
      'price': 'Rp 350.000',
      'rating': '4.9',
      'image': 'assets/images/sipolha1.png',
      'date': '15 July 2026',
    },
    {
      'title': 'Bukit Holbung Camp',
      'location': 'Samosir, Sumut',
      'category': 'Private Trip',
      'price': 'Rp 250.000',
      'rating': '4.8',
      'image': 'assets/images/holbung.png',
      'date': '22 July 2026',
    },
    {
      'title': 'Sipolha Boat Tour',
      'location': 'Danau Toba',
      'category': 'Family Trip',
      'price': 'Rp 850.000',
      'rating': '5.0',
      'image': 'assets/images/sipolha2.png',
      'date': '5 August 2026',
    },
    {
      'title': 'Parbaba Beach Relax',
      'location': 'Samosir, Sumut',
      'category': 'Honeymoon',
      'price': 'Rp 400.000',
      'rating': '4.7',
      'image': 'assets/images/parbaba.png',
      'date': '12 August 2026',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter berdasarkan teks pencarian
    final filteredList = allDestinations.where((trip) {
      final query = _searchQuery.toLowerCase();
      return trip['title'].toLowerCase().contains(query) ||
          trip['location'].toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7DF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF164C55), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'All Popular Escapes',
          style: TextStyle(color: Color(0xFF164C55), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // SEARCH BAR AKTIF
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari destinasi atau lokasi...',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 12.0),
                    child: Icon(Icons.search, color: Color(0xFF164C55)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredList.isEmpty
                ? const Center(child: Text('Destinasi tidak ditemukan!'))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final trip = filteredList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/detail', arguments: trip);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5)),
                      ],
                    ),
                    child: Row(
                      children: [
                        // PERBAIKAN: Menggunakan ClipRRect tanpa ada padding luar agar gambar menempel sempurna di sudut card
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            bottomLeft: Radius.circular(24),
                          ),
                          child: Image.asset(
                            trip['image'],
                            width: 120,
                            height: 125,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        trip['title'],
                                        style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.star_rounded, color: Color(0xFFFFC857), size: 16),
                                        Text(trip['rating'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(trip['location'], style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12)),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      trip['price'],
                                      style: theme.textTheme.displayMedium?.copyWith(
                                        color: const Color(0xFFF5427D),
                                        fontSize: 16,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFF5427D),
                                          minimumSize: Size.zero,
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/detail', arguments: trip);
                                        },
                                        child: const Text('Explore', style: TextStyle(fontSize: 12, color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}