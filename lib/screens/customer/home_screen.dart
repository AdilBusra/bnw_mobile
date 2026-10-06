import 'package:flutter/material.dart';

import 'saved_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContentWidget(),
    const SavedScreen(),
    const TicketsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],

      // FLOATING ACTION BUTTON CHAT AI DIKEMBALIKAN KE HOME
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                // Aksi ketika tombol Chat AI ditekan di Home
              },
              backgroundColor: const Color(0xFFF5427D),
              foregroundColor: Colors.white,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.chat_bubble_rounded),
            )
          : null,

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
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
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

// ==========================================
// KONTEN UTAMA HOME
// ==========================================
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

  final List<String> _promos = [
    'assets/images/promo1.png',
    'assets/images/promo2.png',
  ];

  final List<Map<String, dynamic>> _destinations = [
    {
      'title': 'Sipolha Peak Sunrise',
      'location': 'Sipolha, Simalungun',
      'price': 'Rp 350k',
      'rating': '4.9',
      'image': 'assets/images/sipolha1.png',
      'date': '15 July 2026',
    },
    {
      'title': 'Bukit Holbung Camp',
      'location': 'Samosir, Sumut',
      'price': 'Rp 250k',
      'rating': '4.8',
      'image': 'assets/images/holbung.png',
      'date': '22 July 2026',
    },
    {
      'title': 'Sipolha Boat Tour',
      'location': 'Danau Toba',
      'price': 'Rp 850k',
      'rating': '5.0',
      'image': 'assets/images/sipolha2.png',
      'date': '5 August 2026',
    },
    {
      'title': 'Parbaba Beach Relax',
      'location': 'Samosir, Sumut',
      'price': 'Rp 400k',
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
        globalSavedTrips.removeWhere(
          (element) => element['title'] == trip['title'],
        );
      } else {
        globalSavedTrips.add(trip);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

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
                    Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFF5427D),
                          width: 2,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(
                          'assets/images/profile.png',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // SEARCH BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Find your perfect escape...',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 12.0),
                        child: Icon(Icons.search, color: Color(0xFF164C55)),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFF65D5D5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.tune,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // SLIDER PROMOSI
              Column(
                children: [
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
                            border: Border.all(
                              color: const Color(0xFF164C55).withOpacity(0.15),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            image: DecorationImage(
                              image: AssetImage(_promos[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _promos.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        height: 8.0,
                        width: _currentPromoIndex == index ? 24.0 : 8.0,
                        decoration: BoxDecoration(
                          color: _currentPromoIndex == index
                              ? const Color(0xFFF5427D)
                              : const Color(0xFF164C55).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // KATEGORI
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
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF164C55),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Fredoka',
                        ),
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFFF5427D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                          side: BorderSide(
                            color: isSelected
                                ? Colors.transparent
                                : const Color(0xFFFFD1DC),
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // POPULAR ESCAPES
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Escapes',
                      style: theme.textTheme.displayMedium,
                    ),
                    Text(
                      'See All',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFF5427D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // TRIP CARDS
              SizedBox(
                height: size.height * 0.42,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _destinations.length,
                  itemBuilder: (context, index) {
                    final trip = _destinations[index];
                    final saved = _isSaved(trip);

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: trip,
                        );
                      },
                      child: Container(
                        width: size.width * 0.65,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
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
                                      child: Image.asset(
                                        trip['image'],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: GestureDetector(
                                        onTap: () => _toggleSave(trip),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            saved
                                                ? Icons.favorite
                                                : Icons.favorite_border_rounded,
                                            color: const Color(0xFFF5427D),
                                            size: 20,
                                          ),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          trip['title'],
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                                color: const Color(0xFF164C55),
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star_rounded,
                                            color: Color(0xFFFFC857),
                                            size: 20,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            trip['rating'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF164C55),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: Color(0xFFF5427D),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          trip['location'],
                                          style: theme.textTheme.bodyMedium,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        trip['price'],
                                        style: theme.textTheme.displayMedium
                                            ?.copyWith(
                                              color: const Color(0xFF164C55),
                                              fontSize: 20,
                                            ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFF5427D,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                          minimumSize: Size.zero,
                                          elevation: 4,
                                          shadowColor: const Color(0xFFF5427D)
                                              .withOpacity(0.4),
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/detail',
                                            arguments: trip,
                                          );
                                        },
                                        child: const Text('Book'),
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
                child: Text(
                  'What They Say',
                  style: theme.textTheme.displayMedium,
                ),
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
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(review['image']!),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review['name']!,
                                      style: const TextStyle(
                                        color: Color(0xFF164C55),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (index) => const Icon(
                                          Icons.star_rounded,
                                          color: Color(0xFFFFC857),
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: Text(
                              review['text']!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
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

// ==========================================
// TICKETS SCREEN (HALAMAN MY TICKETS)
// ==========================================
class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> _tickets = [
      {
        'title': 'Sipolha Peak Sunrise',
        'location': 'Sipolha, Simalungun',
        'date': '15 July 2026',
        'type': 'Open Trip',
        'participants': '2 Persons',
        'price': 'Rp 700k',
        'status': 'Confirmed',
        'image': 'assets/images/sipolha1.png',
      },
      {
        'title': 'Bukit Holbung Camp',
        'location': 'Samosir, Sumut',
        'date': '22 August 2026',
        'type': 'Private Trip',
        'participants': '4 Persons',
        'price': 'Rp 1.000k',
        'status': 'Pending Payment',
        'image': 'assets/images/holbung.png',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF7DF), Color(0xFFFFD1DC)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('My Tickets', style: theme.textTheme.displayMedium),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.confirmation_num_rounded,
                        color: Color(0xFFF5427D),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _tickets.isEmpty
                    ? Center(
                        child: Text(
                          'No tickets booked yet, bestie!',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF164C55).withOpacity(0.6),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        itemCount: _tickets.length,
                        itemBuilder: (context, index) {
                          final ticket = _tickets[index];
                          final isConfirmed = ticket['status'] == 'Confirmed';

                          return Container(
                            margin: const EdgeInsets.only(bottom: 20.0),
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
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.asset(
                                          ticket['image'],
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    ticket['title'],
                                                    style: theme
                                                        .textTheme
                                                        .titleLarge
                                                        ?.copyWith(
                                                          fontSize: 16,
                                                        ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: isConfirmed
                                                        ? const Color(
                                                            0xFF65D5D5,
                                                          ).withOpacity(0.2)
                                                        : const Color(
                                                            0xFFFFC857,
                                                          ).withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    ticket['status'],
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isConfirmed
                                                          ? const Color(
                                                              0xFF164C55,
                                                            )
                                                          : const Color(
                                                              0xFF856404,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              ticket['location'],
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(fontSize: 12),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_today_rounded,
                                                  size: 14,
                                                  color: Color(0xFFF5427D),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  ticket['date'],
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF164C55),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                  color: Color(0xFFFFD1DC),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${ticket['type']} • ${ticket['participants']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: const Color(0xFF164C55)
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                      Text(
                                        ticket['price'],
                                        style: theme.textTheme.displayMedium
                                            ?.copyWith(
                                              color: const Color(0xFFF5427D),
                                              fontSize: 16,
                                            ),
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
    );
  }
}

// ==========================================
// PROFILE SCREEN (HALAMAN PROFIL KAYLA - FULL FINAL)
// ==========================================
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Kayla';
  String _email = 'kayla.bestie@beyondwanders.com';
  String _profileImage = 'assets/images/profile.png';

  // 1. POP-UP EDIT PROFILE
  void _showEditProfileDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(
      text: _name,
    );
    final TextEditingController emailController = TextEditingController(
      text: _email,
    );
    String tempImage = _profileImage;

    final List<String> availableImages = [
      'assets/images/profile.png',
      'assets/images/sipolha1.png',
      'assets/images/holbung.png',
      'assets/images/parbaba.png',
    ];

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              backgroundColor: Colors.white,
              title: const Text(
                'Edit Profile ✨',
                style: TextStyle(
                  color: Color(0xFF164C55),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose Profile Picture',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF164C55),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 65,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: availableImages.length,
                          itemBuilder: (context, index) {
                            final img = availableImages[index];
                            final isSelected = tempImage == img;
                            return GestureDetector(
                              onTap: () {
                                setDialogState(() {
                                  tempImage = img;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFF5427D)
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundImage: AssetImage(img),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          filled: true,
                          fillColor: const Color(0xFFFFF7DF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          filled: true,
                          fillColor: const Color(0xFFFFF7DF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF164C55),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF5427D),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _name = nameController.text;
                            _email = emailController.text;
                            _profileImage = tempImage;
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile updated successfully! ✨'),
                            ),
                          );
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 2. POP-UP NOTIFICATIONS
  void _showNotificationsDialog(BuildContext context) {
    final List<Map<String, String>> dummyNotifications = [
      {
        'title': 'Summer Promo Unlocked! ☀️',
        'desc': 'Get 20% off for all Open Trips in Lake Toba this weekend.',
        'time': '2 hours ago',
      },
      {
        'title': 'Booking Confirmed! 🎟️',
        'desc': 'Your trip to Sipolha Peak Sunrise is successfully booked.',
        'time': 'Yesterday',
      },
      {
        'title': 'Welcome to Beyond & Wanders! 🌺',
        'desc': 'Thanks for joining our Island Club aesthetic community.',
        'time': '3 days ago',
      },
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF164C55),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: dummyNotifications.length,
            itemBuilder: (context, index) {
              final notif = dummyNotifications[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7DF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notif['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF164C55),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notif['desc']!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF164C55),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notif['time']!,
                      style: TextStyle(
                        fontSize: 9,
                        color: Color(0xFF164C55).withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(
                color: Color(0xFFF5427D),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeState = context.findAncestorStateOfType<_HomeScreenState>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF7DF), Color(0xFFFFD1DC)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Profile', style: theme.textTheme.displayMedium),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFF5427D),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(_profileImage),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _name,
                              style: theme.textTheme.displayLarge?.copyWith(
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _email,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD1DC),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'Explorer Level 3 🌺',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFF5427D),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Account Settings',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    color: const Color(0xFF164C55),
                  ),
                ),
                const SizedBox(height: 16),
                _buildProfileMenuItem(
                  Icons.person_outline_rounded,
                  'Edit Profile',
                  () => _showEditProfileDialog(context),
                ),
                _buildProfileMenuItem(
                  Icons.favorite_border_rounded,
                  'Saved Wishlist',
                  () {
                    if (homeState != null) {
                      homeState.setState(() {
                        homeState._selectedIndex = 1;
                      });
                    }
                  },
                ),
                _buildProfileMenuItem(
                  Icons.confirmation_num_outlined,
                  'Booking History',
                  () {
                    if (homeState != null) {
                      homeState.setState(() {
                        homeState._selectedIndex = 2;
                      });
                    }
                  },
                ),
                _buildProfileMenuItem(
                  Icons.notifications_outlined,
                  'Notifications',
                  () => _showNotificationsDialog(context),
                ),
                _buildProfileMenuItem(
                  Icons.admin_panel_settings_outlined,
                  'Switch to Admin Portal',
                  () {
                    Navigator.pushNamed(context, '/admin');
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFF5427D),
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          title: const Text(
                            'Log Out',
                            style: TextStyle(
                              color: Color(0xFF164C55),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: const Text(
                            'Are you sure you want to log out, bestie?',
                            style: TextStyle(color: Color(0xFF164C55)),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Color(0xFF164C55)),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/',
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                'Log Out',
                                style: TextStyle(
                                  color: Color(0xFFF5427D),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      'Log Out',
                      style: TextStyle(
                        color: Color(0xFFF5427D),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DM Sans',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5427D).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFFF5427D), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF164C55),
            fontFamily: 'DM Sans',
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Color(0xFF164C55),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
