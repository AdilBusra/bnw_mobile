import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {
        'title': 'Summer Promo Unlocked! ☀️',
        'desc': 'Get 20% off for all Open Trips in Lake Toba this weekend. Claim your voucher now!',
        'time': '2 hours ago',
      },
      {
        'title': 'Booking Confirmed! 🎟️',
        'desc': 'Your trip to Sipolha Peak Sunrise is successfully booked. Prepare your gear!',
        'time': 'Yesterday',
      },
      {
        'title': 'Review Your Trip 📝',
        'desc': 'How was Parbaba Beach Relax? Leave a review and get 500 points.',
        'time': '2 days ago',
      },
      {
        'title': 'Welcome to Beyond & Wanders! 🌺',
        'desc': 'Thanks for joining our Island Club aesthetic community.',
        'time': '1 week ago',
      },
    ];

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
          'Notifications',
          style: TextStyle(color: Color(0xFF164C55), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notif['title']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF164C55),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  notif['desc']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF164C55).withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  notif['time']!,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFF5427D).withOpacity(0.8),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}