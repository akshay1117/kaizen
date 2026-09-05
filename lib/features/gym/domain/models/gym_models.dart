class Exercise {
  final String id;
  final String name;
  final String bodyPart;
  final String target;
  final List<String> secondaryMuscles;
  final String equipment;
  final String mediaId;
  final List<String> instructions;

  Exercise({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.target,
    required this.secondaryMuscles,
    required this.equipment,
    required this.mediaId,
    required this.instructions,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    // Safely extract english instructions from the nested 'instruction_steps' object
    List<String> englishInstructions = [];
    if (json['instruction_steps'] is Map && json['instruction_steps']['en'] is List) {
      englishInstructions = (json['instruction_steps']['en'] as List).map((e) => e.toString()).toList();
    } else if (json['instructions'] is List) {
      // Fallback for older formats
      englishInstructions = (json['instructions'] as List).map((e) => e.toString()).toList();
    }

    return Exercise(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Exercise',
      bodyPart: (json['body_part'] ?? json['bodyPart']) as String? ?? '',
      target: json['target'] as String? ?? '',
      secondaryMuscles: ((json['secondary_muscles'] ?? json['secondaryMuscles']) as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      equipment: json['equipment'] as String? ?? '',
      mediaId: json['media_id'] as String? ?? '',
      instructions: englishInstructions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bodyPart': bodyPart,
      'target': target,
      'secondaryMuscles': secondaryMuscles,
      'equipment': equipment,
      'media_id': mediaId,
      'instructions': instructions,
    };
  }
}

class SplitDay {
  final String dayOfWeek; // e.g., "Monday"
  final String label; // e.g., "Push"
  final List<Exercise> exercises;

  SplitDay({
    required this.dayOfWeek,
    required this.label,
    this.exercises = const [],
  });

  SplitDay copyWith({
    String? label,
    List<Exercise>? exercises,
  }) {
    return SplitDay(
      dayOfWeek: dayOfWeek,
      label: label ?? this.label,
      exercises: exercises ?? this.exercises,
    );
  }

  factory SplitDay.fromJson(Map<String, dynamic> json) {
    return SplitDay(
      dayOfWeek: json['dayOfWeek'] as String? ?? '',
      label: json['label'] as String? ?? '',
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'label': label,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}

class WorkoutSplit {
  final String id;
  final String name;
  final List<SplitDay> days;

  WorkoutSplit({
    required this.id,
    required this.name,
    required this.days,
  });

  factory WorkoutSplit.fromJson(Map<String, dynamic> json) {
    return WorkoutSplit(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      days: (json['days'] as List<dynamic>?)
              ?.map((e) => SplitDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'days': days.map((e) => e.toJson()).toList(),
    };
  }
}
