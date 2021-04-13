import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todo_provider.dart';

class TaskTitleField extends StatefulWidget {
  final String todoDocId;
  final String taskDocId;
  final Map data;

  TaskTitleField(
      {required this.todoDocId, required this.taskDocId, required this.data});

  @override
  _TaskTitleFieldState createState() => _TaskTitleFieldState();
}

class _TaskTitleFieldState extends State<TaskTitleField> {
  late TextEditingController _textController;
  CollectionReference todos = FirebaseFirestore.instance.collection('todos');

  bool editField = false;
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.data['title']);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> updateTitle() {
    return FirebaseFirestore.instance
        .collection('todos/${widget.todoDocId}/tasks/')
        .doc(widget.taskDocId)
        .update({'title': _textController.text})
        .then((value) => {print("task tile Updated")})
        .catchError((error) => print("Failed to update task: $error"));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TodoProvider todoData =
        Provider.of<TodoProvider>(context, listen: true);
    Map data = widget.data;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: data['isComplete'] == null || data['isComplete'] == false
          ? data['title'].isEmpty || todoData.activeTaskId == widget.taskDocId
              ? TextField(
                  controller: _textController,
                  onSubmitted: (String value) async {
                    updateTitle().then((value) => print("Done"));
                  },
                  decoration: InputDecoration(
                    hintText: "Add new Task",
                  ))
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      todoData.setActiveTaskId(widget.taskDocId);
                    },
                    child: Text(
                      data['title'],
                      style: theme.textTheme.headline6!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                )
          : Text(data['title'],
              style: theme.textTheme.headline6!.copyWith(
                  color: Colors.grey.shade600,
                  decoration: TextDecoration.lineThrough)),
    );
  }
}
