import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Tempatkan file logo PNG di assets kalian nantinya
              Image.asset(
                'assets/images/logo.png',
                height: 42,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback jika file PNG logo belum ditaruh di folder assets
                  return const Icon(
                    Icons.travel_explore,
                    size: 38,
                    color: Color(0xFFFE4E7D),
                  );
                },
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Beyond & Wanders Mobile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF3E3E3E),
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'Your Journey Starts Here',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFE4E7D),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Foto Profil / Avatar User
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF3E3E3E), width: 2),
            ),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFFA3EDEE),
              child: Icon(Icons.person, color: Color(0xFF3E3E3E)),
            ),
          ),
        ],
      ),
    );
  }
}