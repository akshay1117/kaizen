import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/services/design_tokens.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: DesignTokens.bgPrimary,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar: "Try Pro for free" on left, Account details on top right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left: Try Pro button
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(0xFF9b51e0), width: 1.5),
                        ),
                        child: const Text(
                          'Try Pro for free',
                          style: TextStyle(
                            color: Color(0xFF9b51e0),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      // Right: Account Details
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.ios_share,
                                color: DesignTokens.textPrimary, size: 20),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.notifications_none,
                                color: DesignTokens.textPrimary, size: 22),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: DesignTokens.bgTertiary,
                              borderRadius: BorderRadius.circular(24),
                              border:
                                  Border.all(color: DesignTokens.borderPrimary),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.grey[700],
                                  child: const Icon(Icons.person,
                                      size: 18, color: Colors.white),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'alexsmith',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: DesignTokens.textPrimary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),


                  // --- STREAK CARDS SECTION ---

                  // 1. Workout Streak Card (Full width featured card)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: DesignTokens.bgSecondary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: DesignTokens.borderPrimary),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: DesignTokens.accentGym.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.local_fire_department,
                                  size: 22, color: DesignTokens.accentGym),
                            ),
                            const Icon(Icons.more_horiz,
                                color: DesignTokens.textSecondary),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '5 Days',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: DesignTokens.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Workout Streak',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: DesignTokens.accentGym,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'You are on fire! 2 more days to beat your personal best streak. Keep pushing!',
                          style: TextStyle(
                            fontSize: 14,
                            color: DesignTokens.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: DesignTokens.accentGym,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Center(
                            child: Text(
                              'Log Workout',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Habit Streak & Journal Streak Cards (Side-by-Side Row)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Habit Streak Card
                      Expanded(
                        child: Container(
                          height: 300,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: DesignTokens.bgSecondary,
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: DesignTokens.borderPrimary),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      DesignTokens.accentHabit.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_circle_outline,
                                    size: 20, color: DesignTokens.accentHabit),
                              ),
                              const Spacer(),
                              const Text(
                                '7 Days',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: DesignTokens.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Habit Streak',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: DesignTokens.accentHabit,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Daily meditation & reading completed.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: DesignTokens.textSecondary,
                                  height: 1.3,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: DesignTokens.bgTertiary,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: DesignTokens.accentHabit
                                          .withValues(alpha: 0.5)),
                                ),
                                child: const Center(
                                  child: Text(
                                    'View Habits',
                                    style: TextStyle(
                                      color: DesignTokens.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Journal Streak Card
                      Expanded(
                        child: Container(
                          height: 300,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: DesignTokens.bgSecondary,
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: DesignTokens.borderPrimary),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      DesignTokens.accentDiet.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit_note,
                                    size: 20, color: DesignTokens.accentDiet),
                              ),
                              const Spacer(),
                              const Text(
                                '3 Days',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: DesignTokens.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Journal Streak',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: DesignTokens.accentDiet,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Evening reflection logged yesterday.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: DesignTokens.textSecondary,
                                  height: 1.3,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: DesignTokens.bgTertiary,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: DesignTokens.accentDiet
                                          .withValues(alpha: 0.5)),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Write Entry',
                                    style: TextStyle(
                                      color: DesignTokens.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: 100), // padding for bottom progress indicator
                ],
              ),
            ),

            // Floating progress widget at bottom left
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: DesignTokens.bgSecondary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 78,
                      height: 78,
                      child: CircularProgressIndicator(
                        value: 0.85,
                        strokeWidth: 5,
                        backgroundColor: DesignTokens.bgTertiary,
                        color: DesignTokens.accentGym,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '85%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: DesignTokens.textPrimary,
                          ),
                        ),
                        Text(
                          'goal met',
                          style: TextStyle(
                            fontSize: 11,
                            color: DesignTokens.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
