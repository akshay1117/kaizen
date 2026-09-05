import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/habits/application/habit_providers.dart';
import 'package:kaizen/core/database/database.dart';

final habitStatsProvider = StreamProvider.family<Map<String, dynamic>, Habit>((ref, habit) {
  final dao = ref.watch(habitsDaoProvider);
  
  // We need all logs to calculate best streak and total check-ins.
  // Using an arbitrary large start date for "all time".
  final now = DateTime.now();
  final allTimeStart = DateTime(2000, 1, 1);
  
  return dao.watchLogsBetweenAll(allTimeStart, now).map((allLogs) {
    // Filter for this specific habit
    final logs = allLogs.where((l) => l.habitId == habit.id).toList();
    
    // Total Check-ins
    int totalCheckIns = 0;
    for (var log in logs) {
      if (log.progress >= habit.targetValue) {
        totalCheckIns++;
      }
    }
    
    // Best Streak
    int bestStreak = 0;
    if (logs.isNotEmpty) {
      // Sort logs by date descending to calculate streak easily
      logs.sort((a, b) => b.completedDate.compareTo(a.completedDate));
      
      int currentStreakCount = 0;
      DateTime? lastDate;
      
      for (var log in logs) {
        if (log.progress < habit.targetValue) continue;
        
        final date = DateTime(log.completedDate.year, log.completedDate.month, log.completedDate.day);
        if (lastDate == null) {
          currentStreakCount = 1;
          lastDate = date;
          if (currentStreakCount > bestStreak) bestStreak = currentStreakCount;
          continue;
        }
        
        final difference = lastDate.difference(date).inDays;
        if (difference == 1) {
          currentStreakCount++;
          lastDate = date;
          if (currentStreakCount > bestStreak) bestStreak = currentStreakCount;
        } else if (difference > 1) {
          currentStreakCount = 1;
          lastDate = date;
        }
      }
    }
    
    // Completion Rate
    final createdDate = DateTime(habit.createdAt.year, habit.createdAt.month, habit.createdAt.day);
    final today = DateTime(now.year, now.month, now.day);
    int daysSinceCreation = today.difference(createdDate).inDays + 1;
    if (daysSinceCreation < 1) daysSinceCreation = 1; // safety
    
    double completionRate = (totalCheckIns / daysSinceCreation) * 100;
    if (completionRate > 100) completionRate = 100; // safety
    
    // Heatmap data (last 20 weeks)
    final Map<DateTime, int> heatmapData = {};
    for (var log in logs) {
      final date = DateTime(log.completedDate.year, log.completedDate.month, log.completedDate.day);
      // We only store if progress >= target
      if (log.progress >= habit.targetValue) {
        heatmapData[date] = 1; // Assuming 1 means completed. We can store progress level if we want varying colors.
      }
    }
    
    return {
      'totalCheckIns': totalCheckIns,
      'bestStreak': bestStreak,
      'completionRate': completionRate.round(),
      'heatmapData': heatmapData,
    };
  });
});
