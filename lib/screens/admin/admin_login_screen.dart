import 'package:flutter/material.dart';
import '../../core/admin/admin_store.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/admin/admin_ui.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});
  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}
class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _key = GlobalKey<FormState>();
  final _email = TextEditingController(), _password = TextEditingController();
  bool _busy = false, _visible = false;
  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }
  Future<void> _login() async {
    if (!_key.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final valid = await AdminStore.instance.login(_email.text, _password.text);
      if (!mounted) return;
      if (valid) { Navigator.pushReplacementNamed(context, '/admin'); }
      else { notice(context, 'Email atau password admin salah.'); }
    } catch (error) { if (mounted) notice(context, 'Login belum berhasil. Coba lagi.'); }
    finally { if (mounted) setState(() => _busy = false); }
  }
  @override
  Widget build(BuildContext context) => Theme(data: AppTheme.lightTheme, child: Scaffold(
    appBar: AppBar(title: const Text('Admin Login')),
    body: SafeArea(child: ListView(padding: const EdgeInsets.all(24), children: [
      const Icon(Icons.admin_panel_settings_outlined, size: 72), const SizedBox(height: 20),
      const Text('Beyond & Wanders', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      const SizedBox(height: 24), Form(key: _key, child: Column(children: [
        TextFormField(controller: _email, enabled: !_busy, keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email admin', prefixIcon: Icon(Icons.email_outlined)),
            validator: (v) => v == null || v.trim().isEmpty ? 'Email wajib diisi' : null),
        const SizedBox(height: 16), TextFormField(controller: _password, enabled: !_busy,
            obscureText: !_visible, autocorrect: false, enableSuggestions: false,
            decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(tooltip: 'Tampilkan / sembunyikan password',
                    onPressed: () => setState(() => _visible = !_visible), icon: Icon(_visible ? Icons.visibility_off : Icons.visibility))),
            validator: (v) => v == null || v.isEmpty ? 'Password wajib diisi' : null),
        const SizedBox(height: 24), if (_busy) const LinearProgressIndicator(),
        const SizedBox(height: 12), FilledButton(onPressed: _busy ? null : _login, child: Text(_busy ? 'Masuk...' : 'Log In')),
      ])),
    ])),
  ));
}
