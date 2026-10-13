import 'package:flutter/material.dart';

import 'saved_screen.dart';
import 'profile_screen.dart';
import 'tickets_screen.dart';
import 'notification_screen.dart';
import 'catalog_screen.dart'; // Import Catalog Screen untuk pencarian & See All

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContentWidget(),
    const SavedScreen(),
    const TicketsScreen(),
    const ProfileScreen(),
  ];

  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: const Border(
            top: BorderSide(color: Color(0xFFFFD1DC), width: 2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: changeTab,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFFF5427D),
            unselectedItemColor: const Color(0xFF164C55).withOpacity(0.5),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled, size: 28),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_rounded, size: 28),
                label: 'Saved',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.confirmation_num_outlined, size: 28),
                label: 'Tickets',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded, size: 28),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContentWidget extends StatefulWidget {
  const HomeContentWidget({super.key});

  @override
  State<HomeContentWidget> createState() => _HomeContentWidgetState();
}

class _HomeContentWidgetState extends State<HomeContentWidget> {
  final List<String> _categories = [
    'All',
    'Open Trip',
    'Private Trip',
    'Family Trip',
    'Honeymoon',
    'Corporate',
  ];
  int _selectedCategory = 0;
  int _currentPromoIndex = 0;

  final TextEditingController _searchController = TextEditingController();

  final List<String> _promos = [
    'assets/images/promo1.png',
    'assets/images/promo2.png',
  ];

  final List<Map<String, dynamic>> _destinations = [
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

  final List<Map<String, String>> _reviews = [
    {
      'name': 'Sarah L.',
      'text': '"Sipolha is totally a hidden gem! The trip was well organized and so aesthetic."',
      'image': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=150&auto=format&fit=crop',
    },
    {
      'name': 'Michelle O.',
      'text': '"Best girls trip ever. The view from Bukit Holbung was breathtaking!"',
      'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=150&auto=format&fit=crop',
    },
  ];

  bool _isSaved(Map<String, dynamic> trip) {
    return globalSavedTrips.any((element) => element['title'] == trip['title']);
  }

  void _toggleSave(Map<String, dynamic> trip) {
    setState(() {
      if (_isSaved(trip)) {
        globalSavedTrips.removeWhere((element) => element['title'] == trip['title']);
      } else {
        globalSavedTrips.add(trip);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    // Filter destinasi berdasarkan kategori
    final filteredDestinations = _selectedCategory == 0
        ? _destinations
        : _destinations.where((d) => d['category'] == _categories[_selectedCategory]).toList();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFFF7DF),
            const Color(0xFFF5427D).withOpacity(0.08),
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hi, Kayla', style: theme.textTheme.displayMedium),
                        const SizedBox(height: 4),
                        Text(
                          'Where to next?',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF164C55).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFFF5427D), size: 28),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NotificationScreen()),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFF5427D), width: 2),
                          ),
                          child: const CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage('assets/images/profile.png'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // SEARCH BAR (AKTIF)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: TextFormField(
                    controller: _searchController,
                    onFieldSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CatalogScreen()),
                        );
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Find your perfect escape...',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 12.0),
                        child: Icon(Icons.search, color: Color(0xFF164C55)),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(color: Color(0xFF65D5D5), shape: BoxShape.circle),
                          child: const Icon(Icons.tune, color: Colors.white, size: 20),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // SLIDER PROMOSI
              SizedBox(
                height: size.height * 0.18,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.9),
                  onPageChanged: (index) {
                    setState(() {
                      _currentPromoIndex = index;
                    });
                  },
                  itemCount: _promos.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        image: DecorationImage(image: AssetImage(_promos[index]), fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // KATEGORI CHIP
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedCategory == index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(_categories[index]),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = index;
                          });
                        },
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF164C55),
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFFF5427D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                          side: BorderSide(
                            color: isSelected ? Colors.transparent : const Color(0xFFFFD1DC),
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // POPULAR ESCAPES & SEE ALL
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Popular Escapes', style: theme.textTheme.displayMedium),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CatalogScreen()),
                        );
                      },
                      child: Text(
                        'See All',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFF5427D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // TRIP CARDS HORIZONTAL
              SizedBox(
                height: size.height * 0.42,
                child: filteredDestinations.isEmpty
                    ? const Center(child: Text('No trips found in this category!'))
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredDestinations.length,
                  itemBuilder: (context, index) {
                    final trip = filteredDestinations[index];
                    final saved = _isSaved(trip);

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/detail', arguments: trip);
                      },
                      child: Container(
                        width: size.width * 0.65,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, 10)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Image.asset(trip['image'], fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                                    ),
                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: GestureDetector(
                                        onTap: () => _toggleSave(trip),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                          child: Icon(saved ? Icons.favorite : Icons.favorite_border_rounded, color: const Color(0xFFF5427D), size: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(trip['title'], style: theme.textTheme.titleLarge?.copyWith(fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.star_rounded, color: Color(0xFFFFC857), size: 18),
                                          Text(trip['rating'], style: const TextStyle(fontWeight: FontWeight.bold)),
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
                                      Text(trip['price'], style: theme.textTheme.displayMedium?.copyWith(color: const Color(0xFFF5427D), fontSize: 16)),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFF5427D),
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          minimumSize: Size.zero,
                                        ),
                                        onPressed: () => Navigator.pushNamed(context, '/detail', arguments: trip),
                                        child: const Text('Book', style: TextStyle(fontSize: 12)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // WHAT THEY SAY
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text('What They Say', style: theme.textTheme.displayMedium),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _reviews.length,
                  itemBuilder: (context, index) {
                    final review = _reviews[index];
                    return Container(
                      width: size.width * 0.75,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(radius: 20, backgroundImage: NetworkImage(review['image']!)),
                              const SizedBox(width: 12),
                              Text(review['name']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF164C55))),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(child: Text(review['text']!, style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12))),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}