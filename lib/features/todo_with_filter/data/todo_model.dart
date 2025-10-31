class TodoModel {
  String? id;
  final String title;
  final bool isDone;
  final DateTime createdAt;

  TodoModel({
    this.id,
    required this.title,
    this.isDone = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
