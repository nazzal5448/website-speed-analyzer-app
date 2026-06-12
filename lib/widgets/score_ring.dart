import 'package:flutter/material.dart';
import 'dart:math';
import '../core/app_colors.dart';

class ScoreRing extends StatelessWidget {
  final double score;
  final double size;
  final double strokeWidth;
  final bool showGlow;

  const ScoreRing({
    super.key,
    required this.score,
    required this.size,
    required this.strokeWidth,
    this.showGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = _getColor(score);
    
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Glow
          if (showGlow)
            Container(
              width: size * 0.8,
              height: size * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            
          // Progress Ring
          CustomPaint(
            size: Size(size, size),
            painter: _ScorePainter(
              score: score,
              color: color,
              strokeWidth: strokeWidth,
            ),
          ),
          
          // Score Text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(score * 100).toInt()}',
                style: TextStyle(
                  fontSize: size * 0.25,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getColor(double score) {
    if (score >= 0.9) return AppColors.green;
    if (score >= 0.5) return AppColors.yellow;
    return AppColors.red;
  }
}

class _ScorePainter extends CustomPainter {
  final double score;
  final Color color;
  final double strokeWidth;

  _ScorePainter({
    required this.score,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    // Draw background track
    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    canvas.drawCircle(center, radius, trackPaint);
    
    // Draw progress
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * score,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
