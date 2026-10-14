import 'package:flutter/material.dart';

class TripFacility {
  final String label;
  final IconData icon;
  final Color color;
  const TripFacility(this.label, this.icon, this.color);
}
const tripFacilities = [
  TripFacility('Transport', Icons.flight_takeoff_rounded, Color(0xFF65D5D5)),
  TripFacility('Stay', Icons.king_bed_rounded, Color(0xFFFFC857)),
  TripFacility('Meals', Icons.restaurant_rounded, Color(0xFFFF8066)),
  TripFacility('Photos', Icons.camera_alt_rounded, Color(0xFFF5427D)),
];

// Same icons, labels, colors and dimensions for customer and admin trip details.
class TripFacilities extends StatelessWidget {
  final List<String> selected;
  const TripFacilities({super.key, this.selected = const ['Transport', 'Stay', 'Meals', 'Photos']});
  @override
  Widget build(BuildContext context) => Wrap(spacing: 22, runSpacing: 18,
    children: tripFacilities.where((f) => selected.contains(f.label)).map((f) => Column(
      mainAxisSize: MainAxisSize.min, children: [
      Container(padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 4))]),
          child: Icon(f.icon, color: f.color, size: 28)),
      const SizedBox(height: 8),
      Text(f.label, style: const TextStyle(color: Color(0xFF164C55), fontWeight: FontWeight.bold, fontFamily: 'DM Sans')),
    ],
    )).toList(),
  );
}
