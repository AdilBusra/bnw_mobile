import 'dart:convert';
import 'package:flutter/material.dart';
import 'saved_screen.dart';
import 'ai_chat_screen.dart';

class TripDetailScreen extends StatefulWidget {
  const TripDetailScreen({super.key});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {

  Widget _buildHeaderImage(Map<String, dynamic> trip) {
    final rawBase64 = trip['imageBase64'] as String?;
    if (rawBase64 != null && rawBase64.trim().isNotEmpty) {
      try {
        final cleaned = rawBase64.contains(',')
            ? rawBase64.split(',').last.trim()
            : rawBase64.trim();
        return Image.memory(
          base64Decode(cleaned),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Image.asset(
            trip['image'] ?? 'assets/images/nature.jfif',
            fit: BoxFit.cover,
          ),
        );
      } catch (_) {
        // Fallback ke asset lokal jika Base64 gagal di-decode
      }
    }
    return Image.asset(
      trip['image'] ?? 'assets/images/nature.jfif',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/nature.jfif',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildFacilityBadge(String label) {
    final lower = label.toLowerCase();
    IconData icon = Icons.check_circle_rounded;
    Color color = const Color(0xFF164C55);

    if (lower.contains('transport') || lower.contains('jemput') || lower.contains('mobil')) {
      icon = Icons.directions_bus_rounded;
      color = const Color(0xFF65D5D5);
    } else if (lower.contains('stay') || lower.contains('hotel') || lower.contains('inap') || lower.contains('tenda')) {
      icon = Icons.king_bed_rounded;
      color = const Color(0xFFFFC857);
    } else if (lower.contains('meal') || lower.contains('makan') || lower.contains('konsumsi')) {
      icon = Icons.restaurant_rounded;
      color = const Color(0xFFFF8066);
    } else if (lower.contains('photo') || lower.contains('foto') || lower.contains('dokumentasi')) {
      icon = Icons.camera_alt_rounded;
      color = const Color(0xFFF5427D);
    } else if (lower.contains('guide') || lower.contains('pemandu')) {
      icon = Icons.support_agent_rounded;
      color = const Color(0xFF5C7AEA);
    } else if (lower.contains('tiket') || lower.contains('masuk')) {
      icon = Icons.confirmation_number_rounded;
      color = const Color(0xFF4CAF50);
    }

    return _buildAmenityIcon(icon, label, color);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    final trip = (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ?? {
      'title': 'Sipolha Peak Sunrise',
      'location': 'Sipolha, Simalungun',
      'price': 'Rp 350.000',
      'rating': '4.9',
      'image': 'assets/images/sipolha1.png',
      'date': '15 July 2026',
    };

    bool isSaved = globalSavedTrips.any((element) => element['title'] == trip['title']);

    void toggleSave() {
      setState(() {
        if (isSaved) {
          globalSavedTrips.removeWhere((element) => element['title'] == trip['title']);
        } else {
          globalSavedTrips.add(trip);
        }
      });
    }

    // Ulasan Pengguna Lain (Review) di Bawah Detail Trip
    final List<Map<String, dynamic>> tripReviews = [
      {
        'name': 'Amanda Putri',
        'rating': 5,
        'comment': 'Pemandangannya sumpah cantik banget! Guide-nya ramah dan dokumentasinya estetik abis. Bakal ikutan open trip lagi sih!',
        'time': '2 weeks ago',
      },
      {
        'name': 'Rian Pratama',
        'rating': 4.8,
        'comment': 'Seru parah! Worth it banget sama harganya. Cocok buat yang mau healing dari penatnya kuliah.',
        'time': '1 month ago',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AiChatScreen(tripTitle: trip['title']),
              ),
            );
          },
          backgroundColor: const Color(0xFFF5427D),
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: const Icon(Icons.chat_bubble_rounded),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFC0CB), Color(0xFFF5427D)],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: size.height * 0.40,
              pinned: true,
              backgroundColor: const Color(0xFFF5427D),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF164C55), size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: toggleSave,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(
                        isSaved ? Icons.favorite : Icons.favorite_border_rounded,
                        color: const Color(0xFFF5427D),
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildHeaderImage(trip),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black26, Colors.transparent, Colors.black45],
                          stops: [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFF7DF), Color(0xFFFFD1DC)],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, -5)),
                  ],
                ),
                transform: Matrix4.translationValues(0.0, -32.0, 0.0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 48.0, 24.0, 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(trip['title'], style: theme.textTheme.displayLarge?.copyWith(fontSize: 28)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xFFFFC857), size: 20),
                                const SizedBox(width: 4),
                                Text(trip['rating'], style: theme.textTheme.titleLarge?.copyWith(fontSize: 16)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, color: Color(0xFFF5427D), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            trip['location'],
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFF164C55).withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, color: Color(0xFF164C55), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${trip['date'] ?? '15 July 2026'} (${trip['category'] ?? 'Open Trip'})',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF164C55),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if ((trip['capacity'] as num?) != null && (trip['capacity'] as num) > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.people_alt_rounded, color: Color(0xFF164C55), size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Kuota: ${trip['capacity']} peserta',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF164C55),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 32),
                    Text('About the trip', style: theme.textTheme.displayMedium),
                    const SizedBox(height: 12),
                    Text(
                      ((trip['description'] as String?)?.trim().isNotEmpty ?? false)
                          ? trip['description']
                          : 'Belum ada deskripsi untuk perjalanan ini.',
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                    ),
                    const SizedBox(height: 32),
                    Text('What\'s included', style: theme.textTheme.displayMedium),
                    const SizedBox(height: 16),
                    Builder(
                      builder: (context) {
                        final facilities = (trip['facilities'] as List?)
                                ?.map((e) => e.toString())
                                .where((e) => e.trim().isNotEmpty)
                                .toList() ??
                            [];

                        if (facilities.isEmpty) {
                          return Text(
                            'Fasilitas mengikuti detail paket trip.',
                            style: theme.textTheme.bodyMedium,
                          );
                        }

                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: facilities
                              .map((item) => _buildFacilityBadge(item))
                              .toList(),
                        );
                      },
                    ),

                      // BAGIAN ULASAN ORANG LAIN DI PALING BAWAH
                      const SizedBox(height: 40),
                      Text('Traveler Reviews 💬', style: theme.textTheme.displayMedium),
                      const SizedBox(height: 16),
                      ...tripReviews.map((review) => Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(review['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF164C55))),
                                Text(review['time'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: List.generate(
                                5,
                                    (i) => Icon(
                                  i < review['rating'] ? Icons.star_rounded : Icons.star_border_rounded,
                                  color: const Color(0xFFFFC857),
                                  size: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(review['comment'], style: const TextStyle(fontSize: 12, color: Color(0xFF164C55), height: 1.4)),
                          ],
                        ),
                      )),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -10)),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Price', style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF164C55).withOpacity(0.6))),
                Text(trip['price'], style: theme.textTheme.displayLarge?.copyWith(color: const Color(0xFFF5427D))),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/booking', arguments: trip);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5427D),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shadowColor: const Color(0xFFF5427D).withOpacity(0.5),
                elevation: 8,
              ),
              child: const Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenityIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
            ],
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF164C55), fontWeight: FontWeight.bold, fontFamily: 'DM Sans'),
        ),
      ],
    );
  }
}