import 'package:flutter/material.dart';
import '../../models/trip_model.dart';

class CatalogScreen extends StatefulWidget {
  final bool isEmbedded;

  const CatalogScreen({super.key, this.isEmbedded = false});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter berdasarkan kategori dan pencarian
    final filteredTrips = dummyTrips.where((trip) {
      final matchesCategory =
          selectedCategory == 'All' || trip.category == selectedCategory;
      final matchesSearch =
          trip.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              trip.location.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    Widget content = SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _buildHeader(context),
          _buildSearchBar(),
          _buildCategoryFilters(),
          _buildCatalogSummary(filteredTrips.length),
          const SizedBox(height: 8),
          if (filteredTrips.isEmpty)
            _buildEmptyState()
          else
            ...filteredTrips.map((trip) => _buildCatalogCard(trip)),
        ],
      ),
    );

    if (widget.isEmbedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFEFBEA),
      body: content,
    );
  }

  // Header Bagian Atas
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Trip Catalog',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF3E3E3E),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Temukan paket liburan impianmu',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFE4E7D),
                ),
              ),
            ],
          ),
          // Badge Ikon Katalog
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFA3EDEE),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF3E3E3E), width: 2),
              boxShadow: const [
                BoxShadow(color: Color(0xFF3E3E3E), offset: Offset(3, 3)),
              ],
            ),
            child: const Icon(
              Icons.travel_explore,
              color: Color(0xFF3E3E3E),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  // Search Bar Interaktif
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF3E3E3E), width: 2),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    searchQuery = val.trim();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari destinasi atau paket...',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              searchQuery = '';
                            });
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFA3EDEE),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF3E3E3E), width: 2),
            ),
            child: const Icon(Icons.search, color: Color(0xFF3E3E3E)),
          ),
        ],
      ),
    );
  }

  // Filter Kategori (All, Private, Group)
  Widget _buildCategoryFilters() {
    final categories = ['All', 'Private', 'Group'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
      child: Row(
        children: categories.map((cat) {
          final isSelected = selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = cat;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFE4E7D)
                      : const Color(0xFFA3EDEE),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF3E3E3E),
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? const [
                          BoxShadow(
                            color: Color(0xFF3E3E3E),
                            offset: Offset(2, 2),
                          )
                        ]
                      : null,
                ),
                child: Text(
                  cat == 'All' ? 'Semua' : cat,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: isSelected ? Colors.white : const Color(0xFF3E3E3E),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Ringkasan Jumlah Paket
  Widget _buildCatalogSummary(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Daftar Paket Wisata',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3E3E3E),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF3E3E3E), width: 1.5),
            ),
            child: Text(
              '$count Paket',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF3E3E3E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Card Katalog Wisata
  Widget _buildCatalogCard(TripModel trip) {
    final formattedPrice = trip.price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3E3E3E), width: 2.5),
        boxShadow: const [
          BoxShadow(color: Color(0xFF3E3E3E), offset: Offset(4, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sisi Kiri: Informasi Text Paket
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      trip.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF3E3E3E),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Kategori Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: trip.category == 'Private'
                            ? const Color(0xFFFE4E7D).withValues(alpha: 0.15)
                            : const Color(0xFFA3EDEE).withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFF3E3E3E),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        trip.category,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF3E3E3E),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: Color(0xFFFE4E7D),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trip.location,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Color(0xFF3E3E3E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trip.dateRange,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Badge Sisa Kuota
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA3EDEE),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFF3E3E3E),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Sisa ${trip.remainingQuota} Kuota',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF3E3E3E),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp $formattedPrice,-',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFFE4E7D),
                  ),
                ),
              ],
            ),
          ),
          // Sisi Kanan: Foto Preview & Tombol CTA
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 85,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA3EDEE).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF3E3E3E),
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.asset(
                      'assets/images/nature.jfif',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.landscape,
                            color: Color(0xFF3E3E3E),
                            size: 36,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Membuka detail ${trip.title} (${trip.location})'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF3E3E3E),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFE4E7D),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: const BorderSide(
                        color: Color(0xFF3E3E3E),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                  ),
                  child: const Text(
                    'Lihat Paket',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tampilan Ketika Hasil Filter Kosong
  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3E3E3E), width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0xFF3E3E3E), offset: Offset(3, 3)),
        ],
      ),
      child: Column(
        children: const [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: Color(0xFFFE4E7D),
          ),
          SizedBox(height: 12),
          Text(
            'Paket tidak ditemukan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3E3E3E),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Coba ubah kata kunci pencarian atau kategori filter.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
