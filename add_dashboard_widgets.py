import re

with open('lib/features/dashboard/presentation/screens/home_screen.dart', 'r') as f:
    content = f.read()

# Add import dart:math
if "import 'dart:math'" not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'dart:math' as math;")

# Add the new widgets
widgets_code = """
class _DashboardMetricsGrid extends StatelessWidget {
  const _DashboardMetricsGrid();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column (Water)
        const Expanded(
          flex: 1,
          child: _WaterIntakeCard(),
        ),
        const SizedBox(width: 16),
        // Right Column (Sleep + Calories)
        Expanded(
          flex: 1,
          child: Column(
            children: const [
              _SleepCard(),
              SizedBox(height: 16),
              _CaloriesCard(),
            ],
          ),
        ),
      ],
    );
  }
}

class _WaterIntakeCard extends StatelessWidget {
  const _WaterIntakeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderSpecular),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Water Intake',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '4 Liters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.accentNeon,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Real time updates',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vertical Progress Bar
              Container(
                width: 24,
                height: 240,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevatedMid,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 24,
                  height: 150, // Example progress height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [AppColors.accentNeon.withValues(alpha: 0.8), AppColors.accentNeon],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Timeline
              Expanded(
                child: Column(
                  children: [
                    _buildTimelineItem('6am - 8am', '600ml', isFirst: true, isLast: false),
                    _buildTimelineItem('9am - 11am', '500ml', isFirst: false, isLast: false),
                    _buildTimelineItem('11am - 2pm', '1000ml', isFirst: false, isLast: false),
                    _buildTimelineItem('2pm - 4pm', '700ml', isFirst: false, isLast: false),
                    _buildTimelineItem('4pm - now', '900ml', isFirst: false, isLast: true),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String time, String amount, {required bool isFirst, required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 16,
            child: CustomPaint(
              painter: _DashedLinePainter(
                color: AppColors.accentVelvet.withValues(alpha: 0.3),
                isFirst: isFirst,
                isLast: isLast,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.accentVelvet.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    amount,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.accentVelvet.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final bool isFirst;
  final bool isLast;

  _DashedLinePainter({required this.color, required this.isFirst, required this.isLast});

  @override
  void paint(Canvas canvas, Size size) {
    if (isLast) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final double startY = 16;
    final double endY = size.height;
    
    double currentY = startY;
    const double dashHeight = 4;
    const double dashSpace = 4;

    while (currentY < endY) {
      canvas.drawLine(
        Offset(size.width / 2, currentY),
        Offset(size.width / 2, currentY + dashHeight),
        paint,
      );
      currentY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SleepCard extends StatelessWidget {
  const _SleepCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderSpecular),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sleep',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '8h 20m',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.accentNeon,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 80,
            width: double.infinity,
            child: CustomPaint(
              painter: _SleepWavePainter(
                color1: AppColors.accentNeon,
                color2: AppColors.accentVelvet,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SleepWavePainter extends CustomPainter {
  final Color color1;
  final Color color2;

  _SleepWavePainter({required this.color1, required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = color1.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final paint2 = Paint()
      ..color = color2.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path1 = Path();
    final path2 = Path();
    final path3 = Path();
    final path4 = Path();

    // Draw intersecting sine waves
    for (double i = 0; i <= size.width; i++) {
      final x = i;
      final normalizedX = x / size.width;
      
      final y1 = size.height / 2 + math.sin(normalizedX * math.pi * 2) * 20;
      final y2 = size.height / 2 + math.sin(normalizedX * math.pi * 2 + 0.5) * 15;
      final y3 = size.height / 2 + math.sin(normalizedX * math.pi * 2 + 1.0) * 25;
      final y4 = size.height / 2 + math.sin(normalizedX * math.pi * 2 + 1.5) * 10;

      if (i == 0) {
        path1.moveTo(x, y1);
        path2.moveTo(x, y2);
        path3.moveTo(x, y3);
        path4.moveTo(x, y4);
      } else {
        path1.lineTo(x, y1);
        path2.lineTo(x, y2);
        path3.lineTo(x, y3);
        path4.lineTo(x, y4);
      }
    }

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint1..strokeWidth = 1.0);
    canvas.drawPath(path3, paint2);
    canvas.drawPath(path4, paint2..strokeWidth = 1.0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CaloriesCard extends StatelessWidget {
  const _CaloriesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderSpecular),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '760 kCal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.accentNeon,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: 0.75, // 75% consumed
                      strokeWidth: 12,
                      backgroundColor: AppColors.surfaceElevatedMid,
                      color: AppColors.accentNeon,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '230kCal',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'left',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.accentNeon.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
"""

if "_DashboardMetricsGrid" not in content:
    content = content + "\n" + widgets_code

# Inject the grid into the HomeScreen layout
if "const _StreaksRow()," in content and "_DashboardMetricsGrid()" not in content:
    content = content.replace(
        "const _StreaksRow(),", 
        "const _StreaksRow(),\n                  const SizedBox(height: 16),\n                  const _DashboardMetricsGrid(),"
    )

with open('lib/features/dashboard/presentation/screens/home_screen.dart', 'w') as f:
    f.write(content)
