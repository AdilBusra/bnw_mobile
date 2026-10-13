import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Fungsionalitas Pop-up Lupa Password
  void _showForgotPasswordDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        title: const Text(
          'Lupa Kata Sandi? 🔑',
          style: TextStyle(color: Color(0xFF164C55), fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan email akunmu. Kami akan mengirimkan instruksi untuk mereset kata sandi.',
              style: TextStyle(fontSize: 12, color: Color(0xFF164C55), height: 1.4),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'email@domain.com',
                filled: true,
                fillColor: const Color(0xFFFFF7DF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF164C55))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5427D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Instruksi pemulihan telah dikirim ke emailmu! 📧'),
                  backgroundColor: Color(0xFF164C55),
                ),
              );
            },
            child: const Text('Kirim', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingEmoji(String emoji, double top, double? left, double? right, double size, double delay) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final offsetY = math.sin((_animationController.value * 2 * math.pi) + delay) * 12;
          return Transform.translate(
            offset: Offset(0, offsetY),
            child: child,
          );
        },
        child: Text(
          emoji,
          style: TextStyle(
            fontSize: size,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: Image.asset(
                'assets/images/img.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.scaffoldBackgroundColor.withOpacity(0.7),
                    const Color(0xFFF5427D).withOpacity(0.15),
                  ],
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: Stack(
              children: [
                _buildFloatingEmoji('🌺', screenHeight * 0.10, screenWidth * 0.10, null, screenWidth * 0.08, 0.0),
                _buildFloatingEmoji('🥥', screenHeight * 0.12, null, screenWidth * 0.15, screenWidth * 0.09, 2.0),
                _buildFloatingEmoji('🐚', screenHeight * 0.28, null, screenWidth * 0.05, screenWidth * 0.07, 4.0),
                _buildFloatingEmoji('✨', screenHeight * 0.38, screenWidth * 0.06, null, screenWidth * 0.1, 1.0),
                _buildFloatingEmoji('🍹', screenHeight * 0.78, screenWidth * 0.10, null, screenWidth * 0.08, 1.5),
                _buildFloatingEmoji('🌴', screenHeight * 0.85, null, screenWidth * 0.10, screenWidth * 0.12, 3.0),
              ],
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Image.asset(
                      'assets/images/logo.png',
                      height: screenHeight * 0.14,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Beyond & Wanders',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displayLarge?.copyWith(
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'Hi, Welcome Back!',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        shadows: [
                          Shadow(
                            color: Colors.white.withOpacity(0.8),
                            blurRadius: 2,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Email Address',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 16.0),
                            child: Icon(Icons.email_outlined, color: Color(0xFF164C55)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 16.0),
                            child: Icon(Icons.lock_outline, color: Color(0xFF164C55)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _showForgotPasswordDialog(context), // Terhubung ke pop-up Lupa Password
                        child: Text(
                          'Forgot Password?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFFF5427D),
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.white.withOpacity(0.8),
                                blurRadius: 2,
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        shadowColor: const Color(0xFFF5427D).withOpacity(0.5),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: const Text('Log in'),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                        ),
                        onPressed: () {},
                        icon: Image.network(
                          'https://cdn-icons-png.flaticon.com/512/2991/2991148.png',
                          height: 24,
                        ),
                        label: const Text('Continue with Google'),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('New to the club?', style: theme.textTheme.bodyMedium),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            'Join Now',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: const Color(0xFF164C55),
                              fontSize: 22,
                              decoration: TextDecoration.underline,
                              decorationColor: const Color(0xFF164C55),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}