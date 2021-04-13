import 'task.dart';

/// Encapsulates todo task items
///
/// [id] is used to group todo tasks
class Todo {
  final int id;
  final String title;
  List<Task> tasks;

  Todo({required this.id, required this.title, required this.tasks});
}
