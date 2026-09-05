import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:kaizen/features/dashboard/presentation/providers/tracker_providers.dart';
import 'package:intl/intl.dart';
import 'package:kaizen/core/database/database.dart';

class _Tokens {
  static const Color background = Color(0xFF121318);
  static const Color surfaceContainerLowest = Color(0xFF0D0E13);
  static const Color surfaceContainerLow = Color(0xFF1A1B21);
  static const Color surfaceContainer = Color(0xFF1E1F25);
  static const Color surfaceContainerHigh = Color(0xFF292A2F);
  static const Color surfaceContainerHighest = Color(0xFF34343A);
  
  static const Color primary = Color(0xFFD0BCFF);
  static const Color primaryContainer = Color(0xFFA078FF);
  static const Color onPrimary = Color(0xFF3C0091);
  
  static const Color secondary = Color(0xFFCEBDFF);
  static const Color secondaryContainer = Color(0xFF4F319C);
  
  static const Color tertiary = Color(0xFF7BD0FF);
  static const Color tertiaryContainer = Color(0xFF009BD1);
  
  static const Color onSurface = Color(0xFFE3E1E9);
  static const Color onSurfaceVariant = Color(0xFFCBC3D7);
  static const Color outline = Color(0xFF958EA0);
  static const Color outlineVariant = Color(0xFF494454);
}

class CalorieTrackingScreen extends ConsumerWidget {
  const CalorieTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final calorieEntriesAsync = ref.watch(calorieEntriesProvider);
    final dailyTotal = ref.watch(caloriesProvider);
    const dailyGoal = 990; 

    return Scaffold(
      backgroundColor: _Tokens.background,
      body: Stack(
        children: [
          // Background Gradient effect
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.5,
                  colors: [
                    _Tokens.secondaryContainer.withValues(alpha: 0.4),
                    _Tokens.background.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: CustomScrollView(
              slivers: [
                _buildAppBar(context),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        _buildHeader(context, selectedDate),
                        const SizedBox(height: 16),
                        _buildDaySwitcher(selectedDate, ref),
                        const SizedBox(height: 24),
                        _buildSummaryHeroCard(dailyTotal, dailyGoal),
                        const SizedBox(height: 16),
                        _buildDailyDistribution(),
                        const SizedBox(height: 24),
                        _buildMealLogsSection(calorieEntriesAsync),
                        const SizedBox(height: 16),
                        _buildWeeklyHistory(),
                        const SizedBox(height: 24),
                        _buildBottomActions(ref, selectedDate),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: _Tokens.surfaceContainerLow.withValues(alpha: 0.8),
      pinned: true,
      centerTitle: true,
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
      ),
      leading: IconButton(
        icon: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: _Tokens.surfaceContainer,
            shape: BoxShape.circle,
          ),
          child: const Icon(LucideIcons.x, size: 20, color: _Tokens.onSurface),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Calorie Expenditure D...',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _Tokens.onSurface,
          letterSpacing: -0.01,
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: _Tokens.primary,
            child: Icon(LucideIcons.user, size: 18, color: _Tokens.onPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, DateTime selectedDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'METABOLIC HUD',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                color: _Tokens.primary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Calorie Tracking',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: _Tokens.onSurface,
                letterSpacing: -0.015,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _Tokens.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.calendar, size: 15, color: _Tokens.primary),
              const SizedBox(width: 4),
              Text(
                'Today, ${DateFormat('MMM d').format(selectedDate)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _Tokens.onSurface,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.expand_more, size: 16, color: _Tokens.outline),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDaySwitcher(DateTime selectedDate, WidgetRef ref) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        final date = today.subtract(Duration(days: 4 - index));
        final isSelected = date.year == selectedDate.year && date.month == selectedDate.month && date.day == selectedDate.day;
        
        return Expanded(
          child: GestureDetector(
            onTap: () {
              ref.read(selectedDateProvider.notifier).state = date;
            },
            child: Container(
              margin: EdgeInsets.only(right: index == 4 ? 0 : 4),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? _Tokens.primary : _Tokens.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected 
                  ? [BoxShadow(color: _Tokens.primary.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))]
                  : null,
              ),
              child: Column(
                children: [
                  Text(
                    index == 4 ? 'TODAY' : DateFormat('E').format(date).toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      letterSpacing: 0.5,
                      color: isSelected ? _Tokens.onPrimary.withValues(alpha: 0.8) : _Tokens.outline,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? _Tokens.onPrimary : _Tokens.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryHeroCard(int consumed, int goal) {
    return Container(
      decoration: BoxDecoration(
        color: _Tokens.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 176,
              height: 176,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _Tokens.secondaryContainer.withValues(alpha: 0.2),
                backgroundBlendMode: BlendMode.screen,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ENERGY CONSUMED',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: _Tokens.outline,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '$consumed',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.5,
                                color: _Tokens.onSurface,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'kcal',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: _Tokens.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _Tokens.secondaryContainer.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: _Tokens.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${(goal - consumed).clamp(0, 9999)} kcal remaining',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _Tokens.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _Tokens.surfaceContainerLowest.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatColumn('CONSUMED', consumed.toString(), _Tokens.onSurface),
                      _buildStatColumn('GOAL', goal.toString(), _Tokens.onSurface),
                      _buildStatColumn('ACTIVE BURN', '410', _Tokens.tertiary),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MACRONUTRIENT TARGET RATIO',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: _Tokens.outline,
                      ),
                    ),
                    Text(
                      '77% Reached',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _Tokens.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: _Tokens.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 38,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: _Tokens.primaryContainer,
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        flex: 44,
                        child: Container(color: _Tokens.secondaryContainer),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        flex: 18,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: _Tokens.tertiaryContainer,
                            borderRadius: BorderRadius.horizontal(right: Radius.circular(5)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMacroLegend('PROTEIN', '68g', ' / 90g', _Tokens.primaryContainer),
                    _buildMacroLegend('CARBS', '82g', ' / 110g', _Tokens.secondaryContainer),
                    _buildMacroLegend('FATS', '24g', ' / 35g', _Tokens.tertiaryContainer),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: _Tokens.outline,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              'kcal',
              style: TextStyle(
                fontSize: 12,
                color: _Tokens.outline,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildMacroLegend(String label, String value, String total, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 4, right: 6),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _Tokens.outline,
              ),
            ),
            RichText(
              text: TextSpan(
                text: value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _Tokens.onSurface,
                ),
                children: [
                  TextSpan(
                    text: total,
                    style: const TextStyle(fontWeight: FontWeight.normal, color: _Tokens.outline),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildDailyDistribution() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _Tokens.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(LucideIcons.barChart2, color: _Tokens.primary, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Daily Distribution',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _Tokens.onSurface,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(width: 8, height: 2, color: _Tokens.outline),
                  const SizedBox(width: 4),
                  const Text(
                    'TARGET PACE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _Tokens.outline,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 144,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: _Tokens.outlineVariant,
                                width: 1,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                          child: CustomPaint(
                            painter: DashedLinePainter(color: _Tokens.outlineVariant),
                          ),
                        ),
                      ),
                      Container(
                        color: _Tokens.surfaceContainer,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: const Text(
                          '300 kcal avg',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _Tokens.outline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBarChartColumn('320', 0.85, 'BKFST', '8:30a', _Tokens.primary),
                    _buildBarChartColumn('110', 0.32, 'M.SNK', '11:00a', _Tokens.secondaryContainer, valueColor: _Tokens.secondary),
                    _buildBarChartColumn('330', 0.88, 'LUNCH', '1:15p', _Tokens.primary),
                    _buildBarChartColumn('-', 0.06, 'A.SNK', 'Pnd', _Tokens.surfaceContainerHighest, isPending: true),
                    _buildBarChartColumn('~230', 0.60, 'DIN', 'Rem', Colors.transparent, isOutline: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChartColumn(String value, double heightFactor, String label, String time, Color color, {bool isPending = false, bool isOutline = false, Color? valueColor}) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isOutline ? FontWeight.bold : FontWeight.w600,
              color: isPending ? _Tokens.outline : (valueColor ?? _Tokens.primary),
            ),
          ),
          const SizedBox(height: 4),
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: 28,
                height: 100 * heightFactor,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                  border: isOutline ? Border.all(color: _Tokens.primary.withValues(alpha: 0.5), width: 1, style: BorderStyle.solid) : null,
                ),
              );
            }
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isOutline ? FontWeight.bold : FontWeight.w600,
              color: isPending ? _Tokens.outline : (isOutline ? _Tokens.primary : _Tokens.onSurfaceVariant),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 10,
              color: _Tokens.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealLogsSection(AsyncValue<List<CalorieEntry>> entriesAsync) {
    final entries = entriesAsync.value ?? [];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Meal Logs & Nutrition',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _Tokens.onSurface,
              ),
            ),
            Text(
              '${entries.length} logged',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _Tokens.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (entries.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text('No meals logged yet', style: TextStyle(color: _Tokens.outline)),
          )
        else
          ...entries.map((entry) {
            IconData icon = LucideIcons.utensils;
            if (entry.mealType.toLowerCase().contains('breakfast')) icon = LucideIcons.croissant;
            if (entry.mealType.toLowerCase().contains('snack')) icon = LucideIcons.apple;
            if (entry.mealType.toLowerCase().contains('lunch') || entry.mealType.toLowerCase().contains('dinner')) icon = LucideIcons.flame;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildMealCard(
                entry.mealType, 
                DateFormat('h:mm a').format(entry.date), 
                entry.name ?? 'Custom meal', 
                entry.calories.toString(), 
                '--', '--', '--', icon
              ),
            );
          }),
      ],
    );
  }

  Widget _buildMealCard(String title, String time, String desc, String kcal, String p, String c, String f, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _Tokens.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _Tokens.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: _Tokens.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: _Tokens.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 12,
                            color: _Tokens.outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      desc,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _Tokens.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    kcal,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _Tokens.onSurface,
                    ),
                  ),
                  const Text(
                    'KCAL',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: _Tokens.outline,
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: _Tokens.outlineVariant, width: 0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildMacroText('P: ', p, _Tokens.primary),
                    const SizedBox(width: 16),
                    _buildMacroText('C: ', c, _Tokens.secondary),
                    const SizedBox(width: 16),
                    _buildMacroText('F: ', f, _Tokens.tertiary),
                  ],
                ),
                const Icon(Icons.more_horiz, color: _Tokens.outline, size: 20),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMacroText(String label, String value, Color color) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontSize: 13,
              color: _Tokens.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyHistory() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _Tokens.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'WEEKLY CALORIC ADHERENCE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: _Tokens.outline,
                ),
              ),
              Text(
                '94% on target',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _Tokens.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildSparkBar('M', 38, _Tokens.secondary),
              _buildSparkBar('T', 42, _Tokens.secondary),
              _buildSparkBar('W', 40, _Tokens.secondary),
              _buildSparkBar('T', 44, _Tokens.secondary),
              _buildSparkBar('F', 34, _Tokens.primary, isToday: true),
              _buildSparkBar('S', 8, _Tokens.outline, opacity: 0.3),
              _buildSparkBar('S', 8, _Tokens.outline, opacity: 0.3),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSparkBar(String day, double height, Color color, {bool isToday = false, double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Column(
        children: [
          Container(
            width: 12,
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            day,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isToday ? _Tokens.primary : _Tokens.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(WidgetRef ref, DateTime selectedDate) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            final repo = ref.read(healthRepositoryProvider);
            await repo.addCalorieEntry(
              'Lunch',
              'Healthy Salad',
              450,
              selectedDate,
            );
          },
          icon: const Icon(LucideIcons.utensilsCrossed, size: 22),
          label: const Text('Log Food or Drink', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: _Tokens.primary,
            foregroundColor: _Tokens.onPrimary,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 10,
            shadowColor: _Tokens.primary.withValues(alpha: 0.25),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Edit Daily Goal & Macronutrient Targets',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _Tokens.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  DashedLinePainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 3, startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
