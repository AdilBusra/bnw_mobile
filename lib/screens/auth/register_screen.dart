import 'package:flutter/material.dart';
import 'dart:math' as math;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF164C55)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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

          // Emoji Melayang (Posisi digeser ke pinggir, atas, dan bawah agar tidak ketutup form)
          IgnorePointer(
            child: Stack(
              children: [
                // Kanan Atas
                _buildFloatingEmoji('🌸', screenHeight * 0.10, null, screenWidth * 0.12, screenWidth * 0.08, 0.0),
                // Kiri Atas
                _buildFloatingEmoji('✨', screenHeight * 0.15, screenWidth * 0.08, null, screenWidth * 0.1, 1.0),
                // Kanan Bawah
                _buildFloatingEmoji('🐚', screenHeight * 0.85, null, screenWidth * 0.10, screenWidth * 0.07, 2.0),
                // Kiri Bawah
                _buildFloatingEmoji('🍹', screenHeight * 0.82, screenWidth * 0.08, null, screenWidth * 0.09, 3.0),
                // Kiri Tengah (mepet pinggir)
                _buildFloatingEmoji('🌴', screenHeight * 0.40, screenWidth * 0.04, null, screenWidth * 0.08, 4.0),
              ],
            ),
          ),

          // Form UI Register
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // JUDUL DENGAN SHADOW
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Join the Club!',
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

                    // SLOGAN BARU
                    Text(
                      'Your Journey Starts Here.',
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

                    // INPUT NAMA LENGKAP
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
                          hintText: 'Full Name',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 16.0),
                            child: Icon(Icons.person_outline, color: Color(0xFF164C55)),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

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

                    SizedBox(height: screenHeight * 0.02),

                    // INPUT KONFIRMASI PASSWORD
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
                          hintText: 'Confirm Password',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 16.0),
                            child: Icon(Icons.lock_outline, color: Color(0xFF164C55)),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // TOMBOL SIGN UP
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        shadowColor: const Color(0xFFF5427D).withOpacity(0.5),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Sign up'), // Teks tombol diganti
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

                    // TEKS LOGIN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?', style: theme.textTheme.bodyMedium),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Log in',
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