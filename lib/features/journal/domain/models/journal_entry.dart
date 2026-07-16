enum Mood {
  happy,
  calm,
  excited,
  sad,
  angry;

  String get emoji {
    switch (this) {
      case Mood.happy:
        return '😊';
      case Mood.calm:
        return '😌';
      case Mood.excited:
        return '😍';
      case Mood.sad:
        return '😢';
      case Mood.angry:
        return '😡';
    }
  }

  String get displayName {
    switch (this) {
      case Mood.happy:
        return 'Happy';
      case Mood.calm:
        return 'Calm';
      case Mood.excited:
        return 'Excited';
      case Mood.sad:
        return 'Sad';
      case Mood.angry:
        return 'Angry';
    }
  }
}

class JournalEntry {
  final String id;
  final String title;
  final String body;
  final List<String> images;
  final String? audioPath;
  final Mood mood;
  final String? prompt;
  final String? location;
  final List<String> tags;
  final bool favorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  const JournalEntry({
    required this.id,
    required this.title,
    required this.body,
    required this.images,
    this.audioPath,
    required this.mood,
    this.prompt,
    this.location,
    required this.tags,
    required this.favorite,
    required this.createdAt,
    required this.updatedAt,
  });

  JournalEntry copyWith({
    String? id,
    String? title,
    String? body,
    List<String>? images,
    String? audioPath,
    Mood? mood,
    String? prompt,
    String? location,
    List<String>? tags,
    bool? favorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      images: images ?? this.images,
      audioPath: audioPath ?? this.audioPath,
      mood: mood ?? this.mood,
      prompt: prompt ?? this.prompt,
      location: location ?? this.location,
      tags: tags ?? this.tags,
      favorite: favorite ?? this.favorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'images': images,
      'audioPath': audioPath,
      'mood': mood.name,
      'prompt': prompt,
      'location': location,
      'tags': tags,
      'favorite': favorite,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      audioPath: json['audioPath'] as String?,
      mood: Mood.values.firstWhere(
        (m) => m.name == json['mood'],
        orElse: () => Mood.happy,
      ),
      prompt: json['prompt'] as String?,
      location: json['location'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      favorite: json['favorite'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
