class PostModel {
  final int? id;
  final int userId;
  final String title;
  final String body;
  final bool isSync; // To track if post is synced with server
  final DateTime createdAt;
  final DateTime? updatedAt;

  PostModel({
    this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.isSync = true,
    required this.createdAt,
    this.updatedAt,
  });

  // Convert from JSON (API response)
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
      isSync: true, // API data is always synced
      createdAt: DateTime.now(),
    );
  }

  // Convert to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {'id': id, 'userId': userId, 'title': title, 'body': body};
  }

  // Convert from SQLite Map
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      body: map['body'],
      isSync: map['isSync'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
    );
  }

  // Convert to SQLite Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'isSync': isSync ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Copy with method for state updates
  PostModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    bool? isSync,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      isSync: isSync ?? this.isSync,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'PostModel(id: $id, userId: $userId, title: $title, body: $body, isSync: $isSync, createdAt: $createdAt)';
  }
}
