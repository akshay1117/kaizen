class WaterEntry {
  final String id;
  final String userId;
  final double amount;
  final DateTime date;
  final DateTime createdAt;

  WaterEntry({
    required this.id,
    required this.userId,
    required this.amount,
    required this.date,
    required this.createdAt,
  });

  factory WaterEntry.fromJson(Map<String, dynamic> json) {
    return WaterEntry(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'date': date.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class SleepRecord {
  final String id;
  final String userId;
  final DateTime bedtime;
  final DateTime wakeupTime;
  final int? sleepScore;
  final DateTime date;
  final DateTime createdAt;

  SleepRecord({
    required this.id,
    required this.userId,
    required this.bedtime,
    required this.wakeupTime,
    this.sleepScore,
    required this.date,
    required this.createdAt,
  });

  factory SleepRecord.fromJson(Map<String, dynamic> json) {
    return SleepRecord(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bedtime: DateTime.parse(json['bedtime'] as String),
      wakeupTime: DateTime.parse(json['wakeup_time'] as String),
      sleepScore: json['sleep_score'] as int?,
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bedtime': bedtime.toIso8601String(),
      'wakeup_time': wakeupTime.toIso8601String(),
      'sleep_score': sleepScore,
      'date': date.toIso8601String().split('T').first,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class CalorieEntry {
  final String id;
  final String userId;
  final String mealType;
  final String? name;
  final int calories;
  final DateTime date;
  final DateTime createdAt;

  CalorieEntry({
    required this.id,
    required this.userId,
    required this.mealType,
    this.name,
    required this.calories,
    required this.date,
    required this.createdAt,
  });

  factory CalorieEntry.fromJson(Map<String, dynamic> json) {
    return CalorieEntry(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      mealType: json['meal_type'] as String,
      name: json['name'] as String?,
      calories: json['calories'] as int,
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'meal_type': mealType,
      'name': name,
      'calories': calories,
      'date': date.toIso8601String().split('T').first,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
