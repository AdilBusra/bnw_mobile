import 'package:flutter/material.dart';
import 'package:bnw_mobile/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart'; // Import home_screen untuk mengakses HomeScreenState

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Memuat nama...';
  String _email = 'Memuat email...';
  String _profileImage = 'assets/images/profile.png';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            // Jika datanya ada, tampilkan namanya
            _name = userDoc.get('name') ?? 'Tanpa Nama';
            _email = userDoc.get('email') ?? currentUser.email ?? '';
          });
        } else {
          setState(() {
            // JIKA DATANYA TIDAK ADA (Akun lama), tampilkan ini
            _name = 'Belum Ada Nama';
            _email = currentUser.email ?? 'Tidak ada email';
          });
        }
      } catch (e) {
        setState(() {
          _name = 'Gagal memuat';
          _email = 'Gagal memuat';
        });
        print("Error mengambil data profil: $e");
      }
    }
  }

  // POP-UP EDIT PROFILE
  void _showEditProfileDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: _name);
    final TextEditingController emailController = TextEditingController(text: _email);
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              backgroundColor: Colors.white,
              title: const Text(
                'Edit Profile ✨',
                style: TextStyle(color: Color(0xFF164C55), fontWeight: FontWeight.bold, fontSize: 20),
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Choose Profile Picture', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF164C55))),
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
                                    color: isSelected ? const Color(0xFFF5427D) : Colors.transparent,
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
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          filled: true,
                          fillColor: const Color(0xFFFFF7DF),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
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
                        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel', style: TextStyle(color: Color(0xFF164C55), fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF5427D),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        // UBAH BAGIAN ONPRESSED INI MENJADI ASYNC
                        onPressed: () async {
                          User? currentUser = FirebaseAuth.instance.currentUser;
                          
                          // 1. Simpan perubahan ke Firestore terlebih dahulu
                          if (currentUser != null) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(currentUser.uid)
                                .update({
                                  'name': nameController.text.trim(),
                                  // Catatan: Biasanya email tidak diubah sembarangan lewat pop-up 
                                  // karena butuh verifikasi keamanan ulang dari Firebase Auth.
                                });
                          }

                          // 2. Perbarui tampilan layar
                          setState(() {
                            _name = nameController.text.trim();
                            // _email = emailController.text; // Kita biarkan email sesuai database
                            _profileImage = tempImage; // Avatar masih tersimpan lokal untuk saat ini
                          });
                          
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated successfully! ✨'))
                          );
                        },
                        child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                      BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFF5427D), width: 2),
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
                              style: theme.textTheme.displayLarge?.copyWith(fontSize: 22),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _email,
                              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD1DC),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'Explorer Level 3 🌺',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFF5427D)),
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
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 18, color: const Color(0xFF164C55)),
                ),
                const SizedBox(height: 16),
                _buildProfileMenuItem(
                  Icons.person_outline_rounded,
                  'Edit Profile',
                      () => _showEditProfileDialog(context),
                ),
                // ROUTING KE SAVED TAB
                _buildProfileMenuItem(
                  Icons.favorite_border_rounded,
                  'Saved Wishlist',
                      () {
                    context.findAncestorStateOfType<HomeScreenState>()?.changeTab(1);
                  },
                ),
                // ROUTING KE TICKETS TAB
                _buildProfileMenuItem(
                  Icons.confirmation_num_outlined,
                  'Booking History',
                      () {
                    context.findAncestorStateOfType<HomeScreenState>()?.changeTab(2);
                  },
                ),
                // MENU NOTIFICATIONS SUDAH DIHAPUS
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
                      side: const BorderSide(color: Color(0xFFF5427D), width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          title: const Text('Log Out', style: TextStyle(color: Color(0xFF164C55), fontWeight: FontWeight.bold)),
                          content: const Text('Are you sure you want to log out, bestie?', style: TextStyle(color: Color(0xFF164C55))),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel', style: TextStyle(color: Color(0xFF164C55))),
                            ),
                            TextButton(
                              onPressed: () async {
                                // 1. Tutup pop-up
                                Navigator.pop(context); 

                                // 2. Panggil fungsi logout Firebase untuk menghapus sesi
                                await AuthService().logout(); 

                                // 3. Karena StreamBuilder di main.dart akan mendeteksi 
                                //    bahwa user sudah logout secara otomatis, kamu tidak perlu 
                                //    menggunakan Navigator.push lagi. StreamBuilder akan 
                                //    langsung mengembalikan layar ke LoginScreen.
                              },
                              child: const Text('Log Out', style: TextStyle(color: Color(0xFFF5427D), fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      'Log Out',
                      style: TextStyle(color: Color(0xFFF5427D), fontWeight: FontWeight.bold, fontFamily: 'DM Sans', fontSize: 16),
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

  Widget _buildProfileMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFFF5427D).withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: const Color(0xFFF5427D), size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF164C55), fontFamily: 'DM Sans')),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF164C55)),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}