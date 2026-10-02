import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final List<String> _tripTypes = ['Open Trip', 'Private Trip', 'Family Trip', 'Honeymoon', 'Corporate'];
  String _selectedTripType = 'Open Trip';

  int _guestCount = 1;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 3));

  final TextEditingController _nameController = TextEditingController(text: 'Kayla');
  final TextEditingController _phoneController = TextEditingController(text: '081234567890');

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trip = (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ?? {
      'title': 'Sipolha Peak Sunrise',
      'location': 'Sipolha, Simalungun',
      'price': 'Rp 350k',
      'rating': '4.9',
      'image': 'assets/images/sipolha1.png',
    };

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
              // APP BAR MANUAL DENGAN JARAK AMAN
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

              // KONTEN UTAMA
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // KARTU RINGKASAN TRIP
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
                              child: Image.asset(
                                trip['image'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trip['title'],
                                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    trip['location'],
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    trip['price'],
                                    style: theme.textTheme.displayMedium?.copyWith(
                                      color: const Color(0xFFF5427D),
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // KATEGORI TRIP
                      Text('Trip Category 🧭', style: theme.textTheme.displayMedium?.copyWith(fontSize: 18)),
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

                      // TANGGAL (JIKA OPEN TRIP TANGGAL FIX, LAINNYA BISA DIKLIK PILIH TANGGAL)
                      Text('Trip Date 📅', style: theme.textTheme.displayMedium?.copyWith(fontSize: 18)),
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
                              Text(
                                _selectedTripType == 'Open Trip'
                                    ? '15 July 2026 (Fixed Open Trip Schedule)'
                                    : '${_selectedDate.day} / ${_selectedDate.month} / ${_selectedDate.year}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _selectedTripType == 'Open Trip'
                                      ? const Color(0xFFF5427D)
                                      : const Color(0xFF164C55),
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

                      // DETAIL PERSONAL
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

                      // JUMLAH PESERTA
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
                                Text('$_guestCount Person', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF164C55))),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: Color(0xFFF5427D)),
                                  onPressed: () => setState(() => _guestCount++),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // TOMBOL CONFIRM & PAY
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
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                title: const Text('Booking Successful! 🎉'),
                                content: Text('Thank you, ${_nameController.text}! Your trip to ${trip['title']} for $_guestCount participant(s) has been booked successfully.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                                    },
                                    child: const Text('Awesome', style: TextStyle(color: Color(0xFFF5427D))),
                                  ),
                                ],
                              ),
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