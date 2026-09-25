import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  // State untuk data profil agar bisa diubah melalui Edit Profile
  String adminName = "Sarah Administrator";
  String adminEmail = "sarah.admin@beyondwanders.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.coconutCream,
              AppColors.softPink,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.deepTeal),
              title: Text(
                "Admin Profile",
                style: GoogleFonts.fredoka(
                  color: AppColors.deepTeal,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // FOTO & INFO PROFIL UTAMA
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.deepTeal.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.softPink,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          adminName,
                          style: GoogleFonts.fredoka(fontSize: 18, color: AppColors.deepTeal),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          adminEmail,
                          style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.greyText),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () {
                            _showEditProfileDialog(context); // Tombol Edit Profile Berfungsi Aktif
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.deepTeal,
                            side: const BorderSide(color: AppColors.deepTeal, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                          ),
                          child: Text("Edit Profile", style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // MENU PENGATURAN (Theme & Help dihapus, Notification disederhanakan)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.deepTeal.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildMenuTile(
                          context,
                          icon: Icons.lock_outline_rounded,
                          title: "Change Password",
                          onTap: () {
                            _showPasswordDialog(context);
                          },
                        ),
                        _buildDivider(),
                        _buildMenuTile(
                          context,
                          icon: Icons.notifications_outlined,
                          title: "Notification", // Disederhanakan dari Notification Settings
                          onTap: () {
                            _showNotificationDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // TOMBOL LOG OUT
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: Text("Log Out", style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 15)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coral,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.coconutCream,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.deepTeal, size: 20),
      ),
      title: Text(title, style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: AppColors.deepTeal, fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.greyText),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: AppColors.deepTeal.withValues(alpha: 0.05), indent: 16, endIndent: 16);
  }

  // POPUP / DIALOG EDIT PROFILE YANG BERFUNGSI AKTIF
  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: adminName);
    final emailController = TextEditingController(text: adminEmail);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Edit Profile", style: GoogleFonts.fredoka(color: AppColors.deepTeal)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Admin Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email Address"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.dmSans(color: AppColors.greyText, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                adminName = nameController.text;
                adminEmail = emailController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profil berhasil diperbarui!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.islandPink,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            ),
            child: Text("Save", style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Change Password", style: GoogleFonts.fredoka(color: AppColors.deepTeal)),
        content: Text("Form to change your admin password will be displayed here.", style: GoogleFonts.dmSans(color: AppColors.deepTeal)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close", style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: AppColors.islandPink)),
          ),
        ],
      ),
    );
  }

  void _showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Notification", style: GoogleFonts.fredoka(color: AppColors.deepTeal)),
        content: Text("Push notifications for bookings and payments are currently active.", style: GoogleFonts.dmSans(color: AppColors.deepTeal)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: AppColors.islandPink)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Log Out", style: GoogleFonts.fredoka(color: AppColors.deepTeal)),
        content: Text("Are you sure you want to exit the admin portal?", style: GoogleFonts.dmSans(color: AppColors.deepTeal)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.dmSans(color: AppColors.greyText, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Berhasil keluar dari Admin Portal')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.coral,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            ),
            child: Text("Log Out", style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}