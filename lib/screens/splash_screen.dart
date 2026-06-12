import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _progressAnimation = Tween<double>(begin: 0.25, end: 0.75).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward().then((_) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // Background Texture Layer
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  AppColors.primary.withOpacity(0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          
          // Background Dots Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: CustomPaint(
                painter: DotsPainter(),
              ),
            ),
          ),

          // HUD Corners
          const HUDCorners(),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 25,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.speed_rounded,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Brand Typography
                const SizedBox(height: 24),
                Text(
                  'Website Speed Analyzer',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 2,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Subtext
                Opacity(
                  opacity: 0.6,
                  child: Text(
                    'Calibrating performance metrics\nfor the high-performance web.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),

          // Bottom Loading Section
          Positioned(
            bottom: 64,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Glowing Loading Bar
                Container(
                  width: 192,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(1),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return Stack(
                        children: [
                          Positioned(
                            left: (MediaQuery.of(context).size.width * 0.5 - 96) * _progressAnimation.value,
                            child: Container(
                              width: 96,
                              height: 2,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                
                // Monospace Loading Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.query_stats,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'INITIALIZING CORE MODULES...',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.primary.withOpacity(0.7),
                        fontSize: 10,
                        letterSpacing: 3,
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

class DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.05);
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HUDCorners extends StatelessWidget {
  const HUDCorners({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Stack(
          children: [
            // Top Left
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white.withOpacity(0.1)),
                    left: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                ),
              ),
            ),
            // Top Right
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white.withOpacity(0.1)),
                    right: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                ),
              ),
            ),
            // Bottom Left
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
                    left: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                ),
              ),
            ),
            // Bottom Right
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
                    right: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
