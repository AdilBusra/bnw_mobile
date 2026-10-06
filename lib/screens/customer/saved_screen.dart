import 'package:flutter/material.dart';

// Global list untuk menyimpan data wishlist yang dibagikan antar halaman
List<Map<String, dynamic>> globalSavedTrips = [
  {
    'title': 'Sipolha Peak Sunrise',
    'location': 'Sipolha, Simalungun',
    'price': 'Rp 350k',
    'rating': '4.9',
    'image': 'assets/images/sipolha1.png',
  },
  {
    'title': 'Bukit Holbung Camp',
    'location': 'Samosir, Sumut',
    'price': 'Rp 250k',
    'rating': '4.8',
    'image': 'assets/images/holbung.png',
  },
];

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF7DF),
              Color(0xFFFFD1DC),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER (EMOJI DIHAPUS)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Saved Escapes',
                      style: theme.textTheme.displayMedium,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite, color: Color(0xFFF5427D)),
                    ),
                  ],
                ),
              ),

              // LIST WISHLIST
              Expanded(
                child: globalSavedTrips.isEmpty
                    ? Center(
                  child: Text(
                    'No saved trips yet, bestie!',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF164C55).withOpacity(0.6),
                    ),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  itemCount: globalSavedTrips.length,
                  itemBuilder: (context, index) {
                    final trip = globalSavedTrips[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              trip['image'],
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
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
                                    // Tombol Hapus dari Saved
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 18, color: Color(0xFF164C55)),
                                      onPressed: () {
                                        setState(() {
                                          globalSavedTrips.removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined, color: Color(0xFFF5427D), size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      trip['location'],
                                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                                    ),
                                  ],
                                ),
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
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFF5427D),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        minimumSize: Size.zero,
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/detail', arguments: trip);
                                      },
                                      child: const Text('Explore', style: TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // TOMBOL CHAT AI PINDAH KE HALAMAN SAVED SESUAI PERMINTAANMU
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi ketika tombol chat AI ditekan
        },
        backgroundColor: const Color(0xFFF5427D),
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.chat_bubble_rounded),
      ),
    );
  }
}