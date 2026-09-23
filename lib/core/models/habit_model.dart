class Habit {
  final String id;
  final String userId;
  final String name;
  final String icon;
  final String color;
  final String frequency;
  final String? reminderTime;
  final int currentStreak;
  final bool isQuantitative;
  final int targetValue;
  final String? unit;
  final String? categories;
  final String streakGoalInterval;
  final DateTime? archivedAt;
  final DateTime createdAt;

  Habit({
    required this.id,
    required this.userId,
    required this.name,
    required this.icon,
    required this.color,
    required this.frequency,
    this.reminderTime,
    this.currentStreak = 0,
    this.isQuantitative = false,
    this.targetValue = 1,
    this.unit,
    this.categories,
    this.streakGoalInterval = 'none',
    this.archivedAt,
    required this.createdAt,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      frequency: json['frequency'] as String,
      reminderTime: json['reminder_time'] as String?,
      currentStreak: json['current_streak'] as int? ?? 0,
      isQuantitative: json['is_quantitative'] as bool? ?? false,
      targetValue: json['target_value'] as int? ?? 1,
      unit: json['unit'] as String?,
      categories: json['categories'] as String?,
      streakGoalInterval: json['streak_goal_interval'] as String? ?? 'none',
      archivedAt: json['archived_at'] != null ? DateTime.parse(json['archived_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'icon': icon,
      'color': color,
      'frequency': frequency,
      'reminder_time': reminderTime,
      'current_streak': currentStreak,
      'is_quantitative': isQuantitative,
      'target_value': targetValue,
      'unit': unit,
      'categories': categories,
      'streak_goal_interval': streakGoalInterval,
      'archived_at': archivedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  Habit copyWith({
    String? id,
    String? userId,
    String? name,
    String? icon,
    String? color,
    String? frequency,
    String? reminderTime,
    int? currentStreak,
    bool? isQuantitative,
    int? targetValue,
    String? unit,
    String? categories,
    String? streakGoalInterval,
    DateTime? archivedAt,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      frequency: frequency ?? this.frequency,
      reminderTime: reminderTime ?? this.reminderTime,
      currentStreak: currentStreak ?? this.currentStreak,
      isQuantitative: isQuantitative ?? this.isQuantitative,
      targetValue: targetValue ?? this.targetValue,
      unit: unit ?? this.unit,
      categories: categories ?? this.categories,
      streakGoalInterval: streakGoalInterval ?? this.streakGoalInterval,
      archivedAt: archivedAt ?? this.archivedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class HabitLog {
  final String id;
  final String habitId;
  final String userId;
  final DateTime completedDate;
  final int progress;
  final String? note;
  final DateTime createdAt;

  HabitLog({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.completedDate,
    this.progress = 1,
    this.note,
    required this.createdAt,
  });

  factory HabitLog.fromJson(Map<String, dynamic> json) {
    return HabitLog(
      id: json['id'] as String,
      habitId: json['habit_id'] as String,
      userId: json['user_id'] as String,
      completedDate: DateTime.parse(json['completed_date'] as String),
      progress: json['progress'] as int? ?? 1,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habit_id': habitId,
      'user_id': userId,
      'completed_date': completedDate.toIso8601String().split('T').first,
      'progress': progress,
      'note': note,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
