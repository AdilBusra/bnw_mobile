import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/trip_service.dart';
import '../../services/user_service.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  Widget _buildTripImage(Map<String, dynamic> trip) {
    final rawBase64 = trip['imageBase64'] as String?;
    if (rawBase64 != null && rawBase64.trim().isNotEmpty) {
      try {
        final cleaned = rawBase64.contains(',')
            ? rawBase64.split(',').last.trim()
            : rawBase64.trim();
        return Image.memory(
          base64Decode(cleaned),
          width: 90,
          height: 90,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Image.asset(
            trip['image'] ?? 'assets/images/nature.jfif',
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
        );
      } catch (_) {}
    }
    return Image.asset(
      trip['image'] ?? 'assets/images/nature.jfif',
      width: 90,
      height: 90,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/nature.jfif',
        width: 90,
        height: 90,
        fit: BoxFit.cover,
      ),
    );
  }

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
                    Text('Saved Escapes', style: theme.textTheme.displayMedium),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite, color: Color(0xFFF5427D)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<UserModel?>(
                  stream: UserService.currentUserStream(),
                  builder: (context, userSnapshot) {
                    final savedIds = userSnapshot.data?.savedTripIds ?? const <String>[];

                    return StreamBuilder<List<TripData>>(
                      stream: TripService.tripsStream(),
                      builder: (context, tripsSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting ||
                            tripsSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(color: Color(0xFFF5427D)),
                          );
                        }

                        final allTrips = tripsSnapshot.data ?? const <TripData>[];
                        final savedTrips = allTrips.where((trip) {
                          final id = (trip['id'] ?? '').toString();
                          final title = (trip['title'] ?? '').toString();
                          return savedIds.contains(id) || savedIds.contains(title);
                        }).toList();

                        if (savedTrips.isEmpty) {
                          return Center(
                            child: Text(
                              'No saved trips yet, bestie!',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: const Color(0xFF164C55).withOpacity(0.6),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          itemCount: savedTrips.length,
                          itemBuilder: (context, index) {
                            final trip = savedTrips[index];
                            final tripId = (trip['id'] ?? trip['title'] ?? '').toString();

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
                                    child: _buildTripImage(trip),
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
                                                trip['title'] ?? 'Trip',
                                                style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.close, size: 18, color: Color(0xFF164C55)),
                                              onPressed: () {
                                                UserService.toggleSavedTrip(
                                                  tripId,
                                                  currentlySaved: true,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on_outlined, color: Color(0xFFF5427D), size: 14),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                trip['location'] ?? '',
                                                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              trip['price'] ?? 'Rp 0',
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
                        );
                      },
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