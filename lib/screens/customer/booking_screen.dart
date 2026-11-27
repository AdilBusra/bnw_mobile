import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/booking_service.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final List<String> _tripTypes = [
    'Open Trip',
    'Private Trip',
    'Family Trip',
    'Honeymoon',
    'Corporate',
  ];
  String _selectedTripType = 'Open Trip';

  int _guestCount = 1;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 3));

  late final TextEditingController _nameController;
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final displayName = FirebaseAuth.instance.currentUser?.displayName ?? '';
    _nameController = TextEditingController(text: displayName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF5427D),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF164C55),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildTripThumbnail(Map<String, dynamic> trip) {
    final rawBase64 = trip['imageBase64'] as String?;
    if (rawBase64 != null && rawBase64.trim().isNotEmpty) {
      try {
        final cleaned = rawBase64.contains(',')
            ? rawBase64.split(',').last.trim()
            : rawBase64.trim();
        return Image.memory(
          base64Decode(cleaned),
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Image.asset(
            trip['image'] ?? 'assets/images/nature.jfif',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        );
      } catch (_) {}
    }
    return Image.asset(
      trip['image'] ?? 'assets/images/nature.jfif',
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/images/nature.jfif',
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    );
  }

  int _extractUnitPrice(Map<String, dynamic> trip) {
    if (trip['rawPrice'] is num) {
      return (trip['rawPrice'] as num).toInt();
    }
    final digits = (trip['price'] ?? '0').toString().replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trip = (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ?? {
      'title': 'Sipolha Peak Sunrise',
      'location': 'Sipolha, Simalungun',
      'price': 'Rp 350.000',
      'rawPrice': 350000,
      'rating': '4.9',
      'image': 'assets/images/sipolha1.png',
      'date': '15 July 2026',
    };

    final unitPrice = _extractUnitPrice(trip);
    final totalAmount = unitPrice * _guestCount;
    final formattedTotal = BookingService.formatRupiah(totalAmount);
    final openTripDate = (trip['date'] as String?)?.isNotEmpty == true
        ? trip['date'] as String
        : '15 July 2026';

    final selectedDateText = _selectedTripType == 'Open Trip'
        ? '$openTripDate (Open Trip)'
        : '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFFF7DF),
              const Color(0xFFF5427D).withOpacity(0.12),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF164C55), size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Complete Your Booking',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF164C55),
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
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
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: _buildTripThumbnail(trip),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trip['title'] ?? 'Trip',
                                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    trip['location'] ?? '',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${BookingService.formatRupiah(unitPrice)} / pax',
                                    style: theme.textTheme.displayMedium?.copyWith(
                                      color: const Color(0xFFF5427D),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Trip Category 🌺', style: theme.textTheme.displayMedium?.copyWith(fontSize: 18)),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedTripType,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: _tripTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type, style: const TextStyle(color: Color(0xFF164C55), fontFamily: 'DM Sans')),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTripType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Text('Trip Date 🗓️', style: theme.textTheme.displayMedium?.copyWith(fontSize: 18)),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          if (_selectedTripType != 'Open Trip') {
                            _selectDate(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  selectedDateText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _selectedTripType == 'Open Trip'
                                        ? const Color(0xFFF5427D)
                                        : const Color(0xFF164C55),
                                  ),
                                ),
                              ),
                              Icon(
                                _selectedTripType == 'Open Trip' ? Icons.lock_outline : Icons.calendar_today_rounded,
                                color: const Color(0xFFF5427D),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Personal Details 👤', style: theme.textTheme.displayMedium?.copyWith(fontSize: 18)),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Full Name',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 16.0),
                            child: Icon(Icons.person_outline, color: Color(0xFF164C55)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Phone Number (WhatsApp)',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 16.0),
                            child: Icon(Icons.phone_outlined, color: Color(0xFF164C55)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Number of Participants 👥', style: theme.textTheme.displayMedium?.copyWith(fontSize: 18)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Participants', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF164C55))),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFF5427D)),
                                  onPressed: () {
                                    if (_guestCount > 1) setState(() => _guestCount--);
                                  },
                                ),
                                Text(
                                  '$_guestCount Person',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF164C55)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: Color(0xFFF5427D)),
                                  onPressed: () => setState(() => _guestCount++),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Payment',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF164C55)),
                            ),
                            Text(
                              formattedTotal,
                              style: theme.textTheme.displayMedium?.copyWith(
                                color: const Color(0xFFF5427D),
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5427D),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 8,
                            shadowColor: const Color(0xFFF5427D).withOpacity(0.5),
                          ),
                          onPressed: () {
                            if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Nama lengkap dan nomor WhatsApp wajib diisi.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            Navigator.pushNamed(
                              context,
                              '/upload_payment',
                              arguments: {
                                'trip': trip,
                                'customerName': _nameController.text.trim(),
                                'customerPhone': _phoneController.text.trim(),
                                'tripCategory': _selectedTripType,
                                'selectedDate': selectedDateText,
                                'participants': _guestCount,
                                'totalAmount': totalAmount,
                                'formattedTotal': formattedTotal,
                              },
                            );
                          },
                          child: const Text('Confirm & Pay'),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}