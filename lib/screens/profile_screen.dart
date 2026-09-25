import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final bool isEmbedded;

  const ProfileScreen({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    Widget content = SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildProfileCard(context),
          const SizedBox(height: 16),
          _buildStatsRow(),
          const SizedBox(height: 24),
          _buildSectionTitle('Aktivitas & Transaksi'),
          const SizedBox(height: 10),
          _buildMenuItem(
            context,
            icon: Icons.receipt_long_rounded,
            title: 'Riwayat Pemesanan',
            subtitle: 'Lihat status tiket & paket liburanmu',
            onTap: () => _showNotice(context, 'Riwayat Pemesanan'),
          ),
          _buildMenuItem(
            context,
            icon: Icons.bookmark_outline_rounded,
            title: 'Wisata Tersimpan',
            subtitle: '14 destinasi impian di wishlist',
            onTap: () => _showNotice(context, 'Wisata Tersimpan'),
          ),
          _buildMenuItem(
            context,
            icon: Icons.account_balance_wallet_outlined,
            title: 'Metode Pembayaran',
            subtitle: 'E-Wallet, Transfer Bank, QRIS',
            onTap: () => _showNotice(context, 'Metode Pembayaran'),
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('Pengaturan & Bantuan'),
          const SizedBox(height: 10),
          _buildMenuItem(
            context,
            icon: Icons.settings_outlined,
            title: 'Pengaturan Akun',
            subtitle: 'Keamanan, notifikasi, dan bahasa',
            onTap: () => _showNotice(context, 'Pengaturan Akun'),
          ),
          _buildMenuItem(
            context,
            icon: Icons.headset_mic_outlined,
            title: 'Pusat Bantuan & FAQ',
            subtitle: 'Hubungi Customer Support kami 24/7',
            onTap: () => _showNotice(context, 'Pusat Bantuan'),
          ),
          const SizedBox(height: 20),
          _buildLogoutButton(context),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Beyond & Wanders Mobile v1.0.0',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );

    if (isEmbedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFEFBEA),
      body: content,
    );
  }

  // Header Judul Screen
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'My Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Color(0xFF3E3E3E),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  // Kartu Profil Pengguna
  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3E3E3E), width: 2.5),
        boxShadow: const [
          BoxShadow(color: Color(0xFF3E3E3E), offset: Offset(4, 4)),
        ],
      ),
      child: Row(
        children: [
          // Avatar dengan border tebal dan badge edit
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF3E3E3E), width: 2.5),
                ),
                child: const CircleAvatar(
                  radius: 34,
                  backgroundColor: Color(0xFFA3EDEE),
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Color(0xFF3E3E3E),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFE4E7D),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF3E3E3E), width: 1.5),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Info Teks Pengguna
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aditya Pratama',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF3E3E3E),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'aditya.wanderer@gmail.com',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                // Member Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA3EDEE),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF3E3E3E), width: 1),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.stars, size: 12, color: Color(0xFFFE4E7D)),
                      SizedBox(width: 4),
                      Text(
                        'Pro Explorer',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF3E3E3E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Row Statistik (Trips, Wishlist, Points)
  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatItem('8', 'Perjalanan', const Color(0xFFA3EDEE)),
        const SizedBox(width: 10),
        _buildStatItem('14', 'Wishlist', Colors.white),
        const SizedBox(width: 10),
        _buildStatItem('2.450', 'Poin BNW', const Color(0xFFFE4E7D), textColor: Colors.white),
      ],
    );
  }

  Widget _buildStatItem(String count, String label, Color bgColor, {Color textColor = const Color(0xFF3E3E3E)}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF3E3E3E), width: 2),
          boxShadow: const [
            BoxShadow(color: Color(0xFF3E3E3E), offset: Offset(3, 3)),
          ],
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: textColor == Colors.white ? Colors.white : const Color(0xFF3E3E3E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Judul Bagian Menu
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: Color(0xFF3E3E3E),
      ),
    );
  }

  // Komponen Item Menu
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3E3E3E), width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0xFF3E3E3E), offset: Offset(2.5, 2.5)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFA3EDEE),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF3E3E3E), width: 1.5),
            ),
            child: Icon(icon, color: const Color(0xFF3E3E3E), size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF3E3E3E),
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: Color(0xFF3E3E3E),
          ),
        ),
      ),
    );
  }

  // Tombol Logout
  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFFFEFBEA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFF3E3E3E), width: 2.5),
            ),
            title: const Text(
              'Konfirmasi Keluar',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF3E3E3E),
              ),
            ),
            content: const Text(
              'Apakah kamu yakin ingin keluar dari akun ini?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF3E3E3E),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Batal',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF3E3E3E),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showNotice(context, 'Berhasil keluar akun');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFE4E7D),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFF3E3E3E), width: 1.5),
                  ),
                ),
                child: const Text(
                  'Ya, Keluar',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF3E3E3E), width: 2),
          boxShadow: const [
            BoxShadow(color: Color(0xFF3E3E3E), offset: Offset(3, 3)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout_rounded, color: Color(0xFFFE4E7D), size: 20),
            SizedBox(width: 8),
            Text(
              'Keluar Akun',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Color(0xFFFE4E7D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotice(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Membuka menu $title'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF3E3E3E),
      ),
    );
  }
}
