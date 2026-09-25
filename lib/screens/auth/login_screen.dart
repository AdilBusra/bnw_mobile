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
          // Background Pemandangan
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: Image.asset(
                'assets/images/img.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradasi Pink
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

          // Emoji Melayang (Posisi diubah agar tidak ketutup form)
          IgnorePointer(
            child: Stack(
              children: [
                // 🌺 Kiri Atas
                _buildFloatingEmoji('🌺', screenHeight * 0.10, screenWidth * 0.10, null, screenWidth * 0.08, 0.0),
                // 🥥 Kanan Atas
                _buildFloatingEmoji('🥥', screenHeight * 0.12, null, screenWidth * 0.15, screenWidth * 0.09, 2.0),
                // 🐚 Kanan Tengah (Diatas email)
                _buildFloatingEmoji('🐚', screenHeight * 0.28, null, screenWidth * 0.05, screenWidth * 0.07, 4.0),
                // ✨ Kiri Tengah (Digeser ke kiri form)
                _buildFloatingEmoji('✨', screenHeight * 0.38, screenWidth * 0.06, null, screenWidth * 0.1, 1.0),
                // 🍹 Kiri Bawah (Di bawah tombol login)
                _buildFloatingEmoji('🍹', screenHeight * 0.78, screenWidth * 0.10, null, screenWidth * 0.08, 1.5),
                // 🌴 Kanan Bawah (Digeser ke pojok kanan bawah agar tidak nabrak teks)
                _buildFloatingEmoji('🌴', screenHeight * 0.85, null, screenWidth * 0.10, screenWidth * 0.12, 3.0),
              ],
            ),
          ),

          // Form UI
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: screenHeight * 0.02),

                    // LOGO UTAMA
                    Image.asset(
                      'assets/images/logo.png',
                      height: screenHeight * 0.14,
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // JUDUL DENGAN SHADOW
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

                    // INPUT EMAIL
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

                    // INPUT PASSWORD
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
                        onPressed: () {},
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

                    // TOMBOL LOGIN
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        shadowColor: const Color(0xFFF5427D).withOpacity(0.5),
                      ),
                      onPressed: () {
                        // KODE BARU: Pindah ke Home Screen
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: const Text('Log in'),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // TOMBOL GOOGLE
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