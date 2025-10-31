class TodoModel {
  String? id;
  final String title;
  final bool isDone;
  final DateTime createdAt;

  TodoModel({required this.title, this.isDone = false})
    : createdAt = DateTime.now();
}
