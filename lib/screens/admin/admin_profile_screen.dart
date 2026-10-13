import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/admin/admin_store.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/admin/admin_ui.dart';
import 'booking_list_screen.dart';
import 'payment_verification_screen.dart';
import 'notifications_screen.dart';

BoxDecoration _profileBox({
  Color color = AppColors.white,
  double radius = 24,
  bool shadow = false,
}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: shadow
        ? [
      BoxShadow(
        color: AppColors.deepTeal.withValues(alpha: 0.08),
        blurRadius: 24,
        offset: const Offset(0, 10),
      ),
    ]
        : null,
  );
}

class AdminProfileScreen extends StatelessWidget {
  final bool embedded;

  const AdminProfileScreen({
    super.key,
    this.embedded = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AdminStore.instance,
      builder: (context, _) {
        final store = AdminStore.instance;

        return AdminPage(
          title: 'Admin Profile',
          embedded: embedded,
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _profileBox(
                  radius: 28,
                  shadow: true,
                ),
                child: Row(
                  children: [
                    Tooltip(
                      message: 'Edit foto dan profil',
                      child: InkWell(
                        onTap: () => openAdmin(
                          context,
                          const EditAdminProfileScreen(),
                        ),
                        borderRadius: BorderRadius.circular(50),
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white,
                                border: Border.all(
                                  color: AppColors.islandPink,
                                  width: 1.5,
                                ),
                              ),
                              child: const AdminAvatar(radius: 32),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColors.islandPink,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: AppColors.white,
                                  size: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.profile.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                              color: AppColors.deepTeal,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            store.profile.email,
                            style: const TextStyle(
                              color: AppColors.deepTeal,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.softPink,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Super Admin',
                              style: TextStyle(
                                color: AppColors.islandPink,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final singleColumn = constraints.maxWidth < 280 ||
                      MediaQuery.textScalerOf(context).scale(1) > 1.4;

                  final width = singleColumn
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 20) / 3;

                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SizedBox(
                        width: width,
                        child: _stat(
                          '${store.trips.length}',
                          'Trips',
                          AppColors.seafoam,
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: _stat(
                          '${store.bookings.length}',
                          'Bookings',
                          AppColors.white,
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: _stat(
                          '${store.pendingPayments.length}',
                          'Need Verify',
                          AppColors.softPink,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              _sectionTitle('Aktivitas & Transaksi'),
              const SizedBox(height: 12),
              _menu(
                context,
                Icons.receipt_long_rounded,
                'Riwayat Pemesanan',
                'Status dan detail pesanan customer',
                const BookingListScreen(),
              ),
              _menu(
                context,
                Icons.account_balance_wallet_outlined,
                'Verifikasi Pembayaran',
                'Daftar pending, verified, dan rejected',
                const PaymentVerificationScreen(),
              ),
              const SizedBox(height: 14),
              _sectionTitle('Pengaturan Akun'),
              const SizedBox(height: 12),
              _menu(
                context,
                Icons.person_outline,
                'Edit Profile',
                'Ubah nama, email, dan foto profil',
                const EditAdminProfileScreen(),
              ),
              _menu(
                context,
                Icons.lock_outline,
                'Change Password',
                'Ganti password akun admin',
                const ChangeAdminPasswordScreen(),
              ),
              _menu(
                context,
                Icons.notifications_outlined,
                'Notifikasi',
                'Pembayaran pending dan peringatan kuota',
                const NotificationsScreen(),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.coconutCream,
                  foregroundColor: AppColors.islandPink,
                  side: const BorderSide(
                    color: AppColors.islandPink,
                    width: 1.3,
                  ),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () async {
                  final confirmed = await confirmAction(
                    context,
                    title: 'Log Out?',
                    message: 'Keluar dari akun admin?',
                    confirmLabel: 'Log Out',
                  );

                  if (!confirmed || !context.mounted) return;

                  store.logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/admin-login',
                        (_) => false,
                  );
                },
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Log Out'),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Beyond & Wanders Mobile v1.1.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.deepTeal.withValues(alpha: 0.65),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.deepTeal,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _stat(String count, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 16,
      ),
      decoration: _profileBox(color: color, radius: 20),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              color: AppColors.deepTeal,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.deepTeal,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menu(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle,
      Widget page,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: () => openAdmin(context, page),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          leading: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.softPink.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.islandPink,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: AppColors.deepTeal,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              subtitle,
              style: TextStyle(
                color: AppColors.deepTeal.withValues(alpha: 0.65),
                fontSize: 11,
              ),
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.deepTeal,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class EditAdminProfileScreen extends StatefulWidget {
  const EditAdminProfileScreen({super.key});

  @override
  State<EditAdminProfileScreen> createState() =>
      _EditAdminProfileScreenState();
}

class _EditAdminProfileScreenState extends State<EditAdminProfileScreen> {
  final _key = GlobalKey<FormState>();
  late final TextEditingController _name, _email;
  String? _photo;
  bool _saving = false, _picking = false, _removePhoto = false;

  @override
  void initState() {
    super.initState();
    final profile = AdminStore.instance.profile;
    _name = TextEditingController(text: profile.name);
    _email = TextEditingController(text: profile.email);
    _photo = profile.photoBase64;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    setState(() => _picking = true);
    try {
      final photo = await pickPhoto();
      if (mounted && photo != null) {
        setState(() {
          _photo = photo;
          _removePhoto = false;
        });
      }
    } catch (error) {
      if (mounted) {
        notice(
          context,
          error is ArgumentError
              ? friendlyError(error)
              : 'Gagal membuka galeri. Periksa izin foto aplikasi.',
        );
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _save() async {
    if (!_key.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await AdminStore.instance.updateProfile(
        _name.text,
        _email.text,
        photoBase64: _photo,
        removePhoto: _removePhoto,
      );
      if (!mounted) return;
      notice(context, 'Profil berhasil diperbarui.');
      Navigator.pop(context);
    } catch (error) {
      if (mounted) notice(context, friendlyError(error));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminPage(
      title: 'Edit Profile',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.lagoonAqua,
                    backgroundImage: _photo == null
                        ? null
                        : MemoryImage(base64Decode(_photo!)),
                    child: _photo == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    TextButton.icon(
                      onPressed: _saving || _picking ? null : _pick,
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(
                        _picking ? 'Membuka galeri...' : 'Ubah Foto',
                      ),
                    ),
                    if (_photo != null)
                      TextButton(
                        onPressed: _saving
                            ? null
                            : () => setState(() {
                          _photo = null;
                          _removePhoto = true;
                        }),
                        child: const Text('Hapus Foto'),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _name,
                  enabled: !_saving,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Nama wajib diisi'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _email,
                  enabled: !_saving,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                  ),
                  validator: (v) => v == null ||
                      !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                          .hasMatch(v.trim())
                      ? 'Email tidak valid'
                      : null,
                ),
                const SizedBox(height: 12),
                const Text('Email ini juga digunakan untuk login admin.'),
                const SizedBox(height: 24),
                if (_saving) const LinearProgressIndicator(),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    OutlinedButton(
                      onPressed: _saving
                          ? null
                          : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: _saving || _picking ? null : _save,
                      child: Text(
                        _saving ? 'Menyimpan...' : 'Save Profile',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChangeAdminPasswordScreen extends StatefulWidget {
  const ChangeAdminPasswordScreen({super.key});

  @override
  State<ChangeAdminPasswordScreen> createState() =>
      _ChangeAdminPasswordScreenState();
}

class _ChangeAdminPasswordScreenState
    extends State<ChangeAdminPasswordScreen> {
  final _key = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  final _visible = [false, false, false];
  bool _saving = false;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_key.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await AdminStore.instance.changePassword(
        _current.text,
        _next.text,
        _confirm.text,
      );
      if (!mounted) return;
      notice(
        context,
        'Password berhasil diubah. Gunakan password baru saat login berikutnya.',
      );
      Navigator.pop(context);
    } catch (error) {
      if (mounted) notice(context, friendlyError(error));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _field(
      String label,
      TextEditingController controller,
      int index,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: !_saving,
        obscureText: !_visible[index],
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            tooltip: _visible[index]
                ? 'Sembunyikan password'
                : 'Tampilkan password',
            onPressed: () => setState(() {
              _visible[index] = !_visible[index];
            }),
            icon: Icon(
              _visible[index]
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ),
        validator: (v) {
          if (v == null || v.isEmpty) return '$label wajib diisi';
          if (index == 1 &&
              (v.length < 8 ||
                  !RegExp(r'[A-Za-z]').hasMatch(v) ||
                  !RegExp(r'\d').hasMatch(v))) {
            return 'Minimal 8 karakter dengan huruf dan angka';
          }
          if (index == 2 && v != _next.text) {
            return 'Konfirmasi password tidak sama';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminPage(
      title: 'Change Password',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Isi password saat ini dan password baru. Password baru minimal 8 karakter, berisi huruf dan angka.',
          ),
          const SizedBox(height: 20),
          Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _field('Current Password', _current, 0),
                _field('New Password', _next, 1),
                _field('Confirm New Password', _confirm, 2),
                if (_saving) const LinearProgressIndicator(),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    OutlinedButton(
                      onPressed: _saving
                          ? null
                          : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: _saving ? null : _save,
                      child: Text(
                        _saving ? 'Menyimpan...' : 'Update Password',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}