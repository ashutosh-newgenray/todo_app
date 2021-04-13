import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';

class TodoTitleField extends StatefulWidget {
  final String documentId;
  String title;
  TodoTitleField({
    required this.documentId,
    required this.title,
  });

  @override
  _TodoTitleFieldState createState() => _TodoTitleFieldState();
}

class _TodoTitleFieldState extends State<TodoTitleField> {
  late TextEditingController _textController;
  CollectionReference todos = FirebaseFirestore.instance.collection('todos');

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.title);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> updateTitle() {
    return todos
        .doc(widget.documentId)
        .update({'title': _textController.text})
        .then((value) => {print("todo tile Updated")})
        .catchError((error) => print("Failed to update todo: $error"));
  }

  @override
  Widget build(BuildContext context) {
    final TodoProvider todoData =
        Provider.of<TodoProvider>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: todoData.activeTodoId == widget.documentId || widget.title.isEmpty
          ? TextField(
              controller: _textController,
              onSubmitted: (String value) async {
                updateTitle().then((value) => setState(() {
                      todoData.setActiveTodoId('');
                    }));
              },
              decoration: InputDecoration(
                hintText: "Create new Todo Item",
              ))
          : FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: InkWell(
                child: Text(widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white)),
                onTap: () {
                  todoData.setActiveTodoId(widget.documentId);
                },
              ),
            ),
    );
  }
}
