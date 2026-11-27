import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/trip_service.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  Widget _buildCardImage(Map<String, dynamic> trip) {
    final rawBase64 = trip['imageBase64'] as String?;
    if (rawBase64 != null && rawBase64.trim().isNotEmpty) {
      try {
        final cleaned = rawBase64.contains(',')
            ? rawBase64.split(',').last.trim()
            : rawBase64.trim();
        return Image.memory(
          base64Decode(cleaned),
          width: 120,
          height: 125,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/images/nature.jfif',
            width: 120,
            height: 125,
            fit: BoxFit.cover,
          ),
        );
      } catch (_) {
        // Fallback ke asset lokal jika string Base64 rusak
      }
    }
    return Image.asset(
      trip['image'] ?? 'assets/images/nature.jfif',
      width: 120,
      height: 125,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/nature.jfif',
        width: 120,
        height: 125,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            child: StreamBuilder<List>(
              stream: TripService.tripsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFF5427D)),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'Gagal memuat trip:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                final allDestinations = snapshot.data ?? [];
                final filteredList = allDestinations.where((trip) {
                  final query = _searchQuery.toLowerCase();
                  return (trip['title'] ?? '').toString().toLowerCase().contains(query) ||
                      (trip['location'] ?? '').toString().toLowerCase().contains(query);
                }).toList();

                if (filteredList.isEmpty) {
                  return const Center(child: Text('Destinasi tidak ditemukan!'));
                }

                return ListView.builder(
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
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                bottomLeft: Radius.circular(24),
                              ),
                              child: _buildCardImage(trip),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}