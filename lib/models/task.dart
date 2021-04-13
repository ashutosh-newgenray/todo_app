class Task {
  final int id;
  String title;
  bool isComplete = false;
  final DateTime dateTime;

  Task({
    required this.id,
    required this.title,
    required this.dateTime,
  });
}
