import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kaizen/features/habits/application/habit_providers.dart';
import 'package:kaizen/features/auth/presentation/providers/auth_provider.dart';
import 'package:kaizen/core/sync/sync_service.dart';
import 'package:kaizen/core/widgets/streak_badge.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:kaizen/features/dashboard/presentation/providers/tracker_providers.dart';
import 'package:kaizen/features/dashboard/presentation/screens/calorie_tracking_screen.dart';
import 'package:kaizen/features/gym/presentation/providers/gym_providers.dart';
import 'package:kaizen/features/journal/providers/journal_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showUserProfileModal(BuildContext context, WidgetRef ref) {
    final user = ref.read(currentUserProvider);
    final displayName = user?.userMetadata?['display_name'] as String? ??
        user?.email?.split('@').first ??
        'User';
    final email = user?.email ?? 'No email';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (modalContext) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.surfaceElevatedLow,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: AppColors.borderSpecular),
              left: BorderSide(color: AppColors.borderSpecular),
              right: BorderSide(color: AppColors.borderSpecular),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.borderActive,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.accentViolet.withValues(alpha: 0.2),
                  child: Text(
                    displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentViolet,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: AppColors.borderSpecular),
                const SizedBox(height: 8),
                Consumer(
                  builder: (context, ref, child) {
                    final syncState = ref.watch(syncServiceProvider);
                    final isLoading = syncState.isLoading;
                    final lastSync = syncState.value;

                    String syncText = 'Never synced';
                    if (lastSync != null) {
                      final timeStr = "${lastSync.hour.toString().padLeft(2, '0')}:${lastSync.minute.toString().padLeft(2, '0')}";
                      syncText = 'Last synced today at $timeStr'; // Simplified for now
                    }

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.accentNeon.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentNeon),
                                ),
                              )
                            : const Icon(Icons.cloud_sync, color: AppColors.accentNeon, size: 20),
                      ),
                      title: const Text(
                        'Data & Sync',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(
                        isLoading ? 'Syncing...' : syncText,
                        style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
                      ),
                      trailing: TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                ref.read(syncServiceProvider.notifier).syncData();
                              },
                        child: const Text(
                          'Sync Now',
                          style: TextStyle(color: AppColors.accentViolet, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.semanticUrgent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.logout, color: AppColors.semanticUrgent, size: 20),
                  ),
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(
                      color: AppColors.semanticUrgent,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: const Text(
                    'Switch account or sign in as another user',
                    style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
                  ),
                  onTap: () async {
                    Navigator.pop(modalContext);
                    await ref.read(authControllerProvider.notifier).signOut();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassScaffold(
      backgroundColor: AppColors.surfacePitchBlack,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileHeader(onProfileTap: () => _showUserProfileModal(context, ref)),
                  const SizedBox(height: 28),

                  const _StreaksRow(),
                  const SizedBox(height: 16),
                  const _DashboardMetricsGrid(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            // Floating progress indicator
            const Positioned(
              top: 16,
              left: 16,
              child: _CircularProgressOverlay(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends ConsumerWidget {
  final VoidCallback onProfileTap;

  const _ProfileHeader({required this.onProfileTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userDisplayName = currentUser?.userMetadata?['display_name'] as String? ??
        currentUser?.email?.split('@').first ??
        'User';

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: onProfileTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevatedMid,
              borderRadius: BorderRadius.circular(AppRadii.xl),
              border: Border.all(color: AppColors.borderSpecular),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.accentViolet.withValues(alpha: 0.25),
                  child: Text(
                    userDisplayName.isNotEmpty ? userDisplayName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentViolet,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  userDisplayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StreaksRow extends ConsumerWidget {
  const _StreaksRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalStreakAsync = ref.watch(globalHabitStreakProvider);
    final globalHabitStreak = globalStreakAsync.value ?? 0;
    
    final gymStreak = ref.watch(currentStreakProvider);
    final journalStreak = ref.watch(journalStreakProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => context.goNamed('fitness'),
            child: StreakBadge(
              streak: gymStreak,
              icon: LucideIcons.flame,
              iconColor: AppColors.accentViolet,
            ),
          ),
          GestureDetector(
            onTap: () => context.goNamed('habits'),
            child: StreakBadge(
              streak: globalHabitStreak,
              icon: Icons.check_circle_outline,
              iconColor: AppColors.semanticPositive,
            ),
          ),
          GestureDetector(
            onTap: () => context.goNamed('journal'),
            child: StreakBadge(
              streak: journalStreak,
              icon: Icons.edit_note,
              iconColor: AppColors.accentVelvet,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularProgressOverlay extends ConsumerWidget {
  const _CircularProgressOverlay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final percentageAsync = ref.watch(dailyHabitCompletionPercentageProvider);
    final percentage = percentageAsync.value ?? 0.0;
    
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedLow,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.surfacePitchBlack.withValues(alpha: 0.5),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              value: percentage,
              strokeWidth: 3,
              backgroundColor: AppColors.surfaceElevatedMid,
              color: AppColors.accentViolet,
            ),
          ),
          Text(
            '${(percentage * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}


class _DashboardMetricsGrid extends StatelessWidget {
  const _DashboardMetricsGrid();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column (Water)
        Expanded(
          flex: 1,
          child: _WaterIntakeCard(),
        ),
        SizedBox(width: 16),
        // Right Column (Sleep + Calories)
        Expanded(
          flex: 1,
          child: Column(
            children: [
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

// Removed local StateProviders in favor of tracker_providers.dart

class _WaterIntakeCard extends ConsumerWidget {
  const _WaterIntakeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waterIntake = ref.watch(waterIntakeProvider);
    return GestureDetector(
      onTap: () => context.pushNamed('water-tracker'),
      child: Container(
        padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderSpecular),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Water Intake',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              InkWell(
                onTap: () => context.pushNamed('water-tracker'),
                child: const Icon(LucideIcons.plusCircle, color: AppColors.accentNeon, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${waterIntake.toStringAsFixed(1)} Liters',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.accentNeon,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Real time updates',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vertical Progress Bar
              Container(
                width: 24,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevatedMid,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 24,
                  height: 100, // Example progress height
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
              padding: const EdgeInsets.only(bottom: 12),
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

    const double startY = 16;
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

class _SleepCard extends ConsumerWidget {
  const _SleepCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleepDuration = ref.watch(sleepDurationProvider);
    final hours = sleepDuration.floor();
    final mins = ((sleepDuration - hours) * 60).round();

    return GestureDetector(
      onTap: () => context.pushNamed('sleep-tracker'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderSpecular),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sleep',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              InkWell(
                onTap: () => context.pushNamed('sleep-tracker'),
                child: const Icon(LucideIcons.plusCircle, color: AppColors.accentNeon, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${hours}h ${mins}m',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.accentNeon,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
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

class _CaloriesCard extends ConsumerWidget {
  const _CaloriesCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calories = ref.watch(caloriesProvider);
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CalorieTrackingScreen())),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderSpecular),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Calories',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CalorieTrackingScreen())),
                child: const Icon(LucideIcons.plusCircle, color: AppColors.accentNeon, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$calories kCal',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.accentNeon,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: 72,
              height: 72,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      value: calories / 2500, // 2500 is target
                      strokeWidth: 8,
                      backgroundColor: AppColors.surfaceElevatedMid,
                      color: AppColors.accentNeon,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(2500 - calories).clamp(0, 2500)}',
                        style: const TextStyle(
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
      ),
    );
  }
}
