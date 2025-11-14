class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.isCompleted = false,
  });

  Task copyWith({String? title, String? description, bool? isCompleted}) => Task(
    id: id,
    title: title ?? this.title,
    description: description ?? this.description,
    createdAt: createdAt,
    isCompleted: isCompleted ?? this.isCompleted,
  );
}
//