class JournalEntry {
  final String id;
  final String userId;
  final String content;
  final int? mood;
  final String? moduleRef;
  final String? refId;
  final DateTime entryDate;
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.userId,
    required this.content,
    this.mood,
    this.moduleRef,
    this.refId,
    required this.entryDate,
    required this.createdAt,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      mood: json['mood'] as int?,
      moduleRef: json['module_ref'] as String?,
      refId: json['ref_id'] as String?,
      entryDate: DateTime.parse(json['entry_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'content': content,
      'mood': mood,
      'module_ref': moduleRef,
      'ref_id': refId,
      'entry_date': entryDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
