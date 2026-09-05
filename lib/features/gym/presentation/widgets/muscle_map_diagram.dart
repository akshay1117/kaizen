import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';

class MuscleMapDiagram extends StatelessWidget {
  final Map<MuscleGroup, double> recovery;
  final double width;
  final double height;

  const MuscleMapDiagram({
    super.key,
    required this.recovery,
    this.width = 300,
    this.height = 400,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: GymTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background grid/decoration
          CustomPaint(
            size: Size(width, height),
            painter: _BackgroundGridPainter(),
          ),
          // The actual body map
          CustomPaint(
            size: Size(width * 0.7, height * 0.9),
            painter: _MuscleMapPainter(recovery: recovery),
          ),
        ],
      ),
    );
  }
}

class _BackgroundGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = GymTheme.pillUnselected.withValues(alpha: 0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const step = 20.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MuscleMapPainter extends CustomPainter {
  final Map<MuscleGroup, double> recovery;

  _MuscleMapPainter({required this.recovery});

  Color _getColor(MuscleGroup muscle) {
    final rec = recovery[muscle] ?? 1.0;
    if (rec < 0.3) {
      return GymTheme.destructive; // Exhausted
    } else if (rec < 0.7) {
      return Colors.orangeAccent; // Recovering
    } else {
      return GymTheme.pillUnselected.withValues(alpha: 0.5); // Rested
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // We define a 100x100 coordinate system and scale it to the available size.
    final double scaleX = size.width / 100;
    final double scaleY = size.height / 100;

    void drawNode(double x, double y, double r, MuscleGroup muscle) {
      final paint = Paint()
        ..color = _getColor(muscle)
        ..style = PaintingStyle.fill;
      
      final glowPaint = Paint()
        ..color = _getColor(muscle).withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
        ..style = PaintingStyle.fill;

      final center = Offset(x * scaleX, y * scaleY);
      final radius = r * scaleX;

      if ((recovery[muscle] ?? 1.0) < 0.7) {
        canvas.drawCircle(center, radius, glowPaint);
      }
      canvas.drawCircle(center, radius, paint);
      
      // Border
      canvas.drawCircle(
        center, 
        radius, 
        Paint()
          ..color = AppColors.textPrimary.withValues(alpha: 0.2)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke
      );
    }

    void drawSymmetricNode(double x, double y, double r, MuscleGroup muscle) {
      drawNode(x, y, r, muscle);
      drawNode(100 - x, y, r, muscle); // Mirrored across 50
    }
    
    // Draw wireframe connections
    final linePaint = Paint()
      ..color = GymTheme.pillUnselected.withValues(alpha: 0.2)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    void drawLine(double x1, double y1, double x2, double y2) {
      canvas.drawLine(
        Offset(x1 * scaleX, y1 * scaleY),
        Offset(x2 * scaleX, y2 * scaleY),
        linePaint,
      );
    }

    void drawSymmetricLine(double x1, double y1, double x2, double y2) {
      drawLine(x1, y1, x2, y2);
      drawLine(100 - x1, y1, 100 - x2, y2);
    }

    // Spine/Torso lines
    drawLine(50, 15, 50, 50); // Neck to Pelvis
    drawSymmetricLine(50, 25, 30, 25); // Shoulders
    drawSymmetricLine(30, 25, 20, 55); // Arms
    drawSymmetricLine(50, 50, 35, 75); // Upper Legs
    drawSymmetricLine(35, 75, 35, 95); // Lower Legs

    // Head (Decoration)
    canvas.drawCircle(
      Offset(50 * scaleX, 8 * scaleY), 
      6 * scaleX, 
      Paint()
        ..color = GymTheme.pillUnselected.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
    );

    // Draw Muscles
    drawSymmetricNode(30, 25, 5, MuscleGroup.shoulders);
    drawSymmetricNode(40, 30, 6, MuscleGroup.chest);
    drawNode(50, 35, 6, MuscleGroup.back);
    
    drawSymmetricNode(25, 38, 4, MuscleGroup.biceps);
    drawSymmetricNode(18, 40, 3.5, MuscleGroup.triceps);
    drawSymmetricNode(15, 55, 3.5, MuscleGroup.forearms);

    drawNode(50, 48, 5, MuscleGroup.abs);
    drawSymmetricNode(38, 45, 4, MuscleGroup.obliques);

    drawSymmetricNode(42, 58, 5, MuscleGroup.glutes);
    drawSymmetricNode(35, 70, 5.5, MuscleGroup.quads);
    drawSymmetricNode(45, 70, 4.5, MuscleGroup.hamstrings);
    
    drawSymmetricNode(45, 65, 3, MuscleGroup.adductors);
    drawSymmetricNode(25, 65, 3, MuscleGroup.abductors);

    drawSymmetricNode(35, 88, 4.5, MuscleGroup.calves);
    drawSymmetricNode(42, 88, 3.5, MuscleGroup.tibialisAnterior);
  }

  @override
  bool shouldRepaint(covariant _MuscleMapPainter oldDelegate) {
    return oldDelegate.recovery != recovery;
  }
}
