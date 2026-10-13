import 'package:flutter/material.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  // POPUP REVIEW
  void _showReviewDialog(BuildContext context, String title) {
    int rating = 5;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: const Text('Rate Your Trip 🌟', style: TextStyle(color: Color(0xFF164C55), fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('How was your experience at $title?', textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF164C55))),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                          color: const Color(0xFFFFC857),
                          size: 32,
                        ),
                        onPressed: () {
                          setDialogState(() {
                            rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Share your thoughts...',
                      filled: true,
                      fillColor: const Color(0xFFFFF7DF),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Color(0xFF164C55))),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5427D),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you for your review! 🌺')));
                  },
                  child: const Text('Submit', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // POPUP DETAIL BOOKING HASIL PEMESANAN
  void _showBookingDetailDialog(BuildContext context, Map<String, dynamic> ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.confirmation_num_rounded, color: Color(0xFFF5427D)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Booking Details',
                style: const TextStyle(color: Color(0xFF164C55), fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(ticket['image'], width: 120, height: 90, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            Text(ticket['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF164C55))),
            const SizedBox(height: 4),
            Text(ticket['location'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const Divider(height: 24, color: Color(0xFFFFD1DC)),
            _detailRow('Status', ticket['status']),
            _detailRow('Trip Date', ticket['date']),
            _detailRow('Trip Type', ticket['type']),
            _detailRow('Participants', ticket['participants']),
            _detailRow('Total Price', ticket['price']),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5427D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF164C55))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> tickets = [
      {
        'title': 'Sipolha Peak Sunrise',
        'location': 'Sipolha, Simalungun',
        'date': '15 July 2026',
        'type': 'Open Trip',
        'participants': '2 Persons',
        'price': 'Rp 700.000',
        'status': 'Confirmed',
        'image': 'assets/images/sipolha1.png',
      },
      {
        'title': 'Bukit Holbung Camp',
        'location': 'Samosir, Sumut',
        'date': '22 August 2026',
        'type': 'Private Trip',
        'participants': '4 Persons',
        'price': 'Rp 1.000.000',
        'status': 'Pending Payment',
        'image': 'assets/images/holbung.png',
      },
      {
        'title': 'Parbaba Beach Relax',
        'location': 'Samosir, Sumut',
        'date': '12 June 2026',
        'type': 'Family Trip',
        'participants': '5 Persons',
        'price': 'Rp 400.000',
        'status': 'Completed',
        'image': 'assets/images/parbaba.png',
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
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.confirmation_num_rounded, color: Color(0xFFF5427D)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: tickets.isEmpty
                    ? Center(
                  child: Text(
                    'No tickets booked yet, bestie!',
                    style: theme.textTheme.bodyLarge?.copyWith(color: const Color(0xFF164C55).withOpacity(0.6)),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    final isConfirmed = ticket['status'] == 'Confirmed';
                    final isCompleted = ticket['status'] == 'Completed';

                    return GestureDetector(
                      onTap: () => _showBookingDetailDialog(context, ticket),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5)),
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
                                    child: Image.asset(ticket['image'], width: 80, height: 80, fit: BoxFit.cover),
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
                                                ticket['title'],
                                                style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: isCompleted
                                                    ? const Color(0xFF4CAF50).withOpacity(0.2)
                                                    : isConfirmed
                                                    ? const Color(0xFF65D5D5).withOpacity(0.2)
                                                    : const Color(0xFFFFC857).withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                ticket['status'],
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: isCompleted
                                                      ? const Color(0xFF2E7D32)
                                                      : isConfirmed
                                                      ? const Color(0xFF164C55)
                                                      : const Color(0xFF856404),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(ticket['location'], style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12)),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFFF5427D)),
                                            const SizedBox(width: 4),
                                            Text(
                                              ticket['date'],
                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF164C55)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: Color(0xFFFFD1DC)),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${ticket['type']} • ${ticket['participants']}',
                                    style: TextStyle(fontSize: 12, color: const Color(0xFF164C55).withOpacity(0.7)),
                                  ),
                                  if (isCompleted)
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFF5427D),
                                        minimumSize: Size.zero,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      onPressed: () => _showReviewDialog(context, ticket['title']),
                                      child: const Text('Review', style: TextStyle(fontSize: 12, color: Colors.white)),
                                    )
                                  else
                                    Text(
                                      ticket['price'],
                                      style: theme.textTheme.displayMedium?.copyWith(color: const Color(0xFFF5427D), fontSize: 16),
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
            ],
          ),
        ),
      ),
    );
  }
}