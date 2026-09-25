import 'package:flutter/material.dart';
import '../models/trip_model.dart';
import '../widgets/header_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/hero_banner_widget.dart';
import '../widgets/category_filter_widget.dart';
import '../widgets/trip_card_widget.dart';
import 'catalog_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  int selectedNavIndex = 0;

  Widget _buildHomeContent(List<TripModel> filteredTrips) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const HeaderWidget(),
          const SearchBarWidget(),
          const HeroBannerWidget(),
          CategoryFilterWidget(
            selectedCategory: selectedCategory,
            onSelectCategory: (cat) {
              setState(() {
                selectedCategory = cat;
              });
            },
          ),
          const SizedBox(height: 10),
          ...filteredTrips.map((trip) => TripCardWidget(trip: trip)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter Trip sesuai kategori yang dipilih
    final filteredTrips = dummyTrips.where((trip) {
      if (selectedCategory == 'All') return true;
      return trip.category == selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFEFBEA), // Background Maximalist Warm White
      body: IndexedStack(
        index: selectedNavIndex,
        children: [
          _buildHomeContent(filteredTrips),
          const CatalogScreen(isEmbedded: true),
          const ProfileScreen(isEmbedded: true),
        ],
      ),

      // FAB: Ikon AI Chatbot Assistant di Pojok Kanan Bawah
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi untuk membuka AI Chatbot nantinya
        },
        backgroundColor: const Color(0xFFFE4E7D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF3E3E3E), width: 2),
        ),
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF3E3E3E), width: 2)),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedNavIndex,
          onTap: (index) {
            setState(() {
              selectedNavIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFFE4E7D),
          unselectedItemColor: const Color(0xFF3E3E3E),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 28),
              activeIcon: Icon(Icons.home, size: 28),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined, size: 28),
              activeIcon: Icon(Icons.storefront, size: 28),
              label: 'Catalog',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 28),
              activeIcon: Icon(Icons.person, size: 28),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}