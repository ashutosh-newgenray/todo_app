import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/widgets/task_title_field.dart';
import 'package:intl/intl.dart';

class TodoTaskItem extends StatefulWidget {
  final ValueKey key;
  final String todoDocId;
  final String taskDocId;
  final int colorValue;
  final Map data;

  TodoTaskItem(
      {required this.key,
      required this.todoDocId,
      required this.taskDocId,
      required this.colorValue,
      required this.data});

  @override
  _TodoTaskItemState createState() => _TodoTaskItemState();
}

class _TodoTaskItemState extends State<TodoTaskItem> {
  bool strike = false;

  bool editItem = false;

  late TextEditingController _textController;

  DateTime selectedDate = DateTime.now();

  deleteTask() {
    FirebaseFirestore.instance
      ..collection('todos/${widget.todoDocId}/tasks/')
          .doc(widget.taskDocId)
          .delete()
          .then((value) => FirebaseFirestore.instance
              .collection('todos')
              .doc(widget.todoDocId)
              .update({"taskCount": FieldValue.increment(-1)}));
  }

  _selectDate(BuildContext context, todoData) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;

        todoData.updateTask(
            widget.todoDocId, widget.taskDocId, {'reminder': picked.toLocal()});
      });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    String? date = null;
    final TodoProvider todoData =
        Provider.of<TodoProvider>(context, listen: false);
    if (widget.data['reminder'] != null) {
      Timestamp reminder = widget.data['reminder'];
      date = DateFormat.yMMMEd().format(reminder.toDate());
    }
    return Dismissible(
      key: ValueKey(widget.taskDocId),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(20),
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(20),
        child: Icon(
          Icons.close,
          color: Colors.red,
        ),
      ),
      confirmDismiss: (direction) {
        return Future(() {
          if (direction == DismissDirection.startToEnd) {
            todoData.updateTask(
                widget.todoDocId, widget.taskDocId, {'isComplete': true});
            return false;
          } else {
            deleteTask();
            return true;
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 1),
        decoration: BoxDecoration(
          color: !strike
              ? widget.data['isComplete'] == true
                  ? theme.primaryColor
                  : Color.fromARGB(255, 255, widget.colorValue, 82)
              : Colors.green,
        ),
        child: ListTile(
          onTap: () {
            todoData.setActiveTaskId('');
          },
          trailing: Text(widget.data['priority'].toString()),
          title: TaskTitleField(
              todoDocId: widget.todoDocId,
              taskDocId: widget.taskDocId,
              data: widget.data),
          subtitle: widget.data['title'].isEmpty
              ? TextButton(
                  style: ButtonStyle(
                    alignment: AlignmentDirectional.centerStart,
                  ),
                  onPressed: () {
                    _selectDate(context, todoData);
                  },
                  child: Text(
                    date == null ? "Add Reminder" : date,
                    style: Theme.of(context).textTheme.caption,
                  ))
              : null,
        ),
      ),
    );
  }
}
