import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todo_provider.dart';

import '../screens/todo_task_screen.dart';
import 'todo_title_field.dart';

class TodoTaskItem extends StatelessWidget {
  final _item;
  TodoTaskItem(this._item);

  Future<void> deleteTodo() {
    DocumentReference todoRef =
        FirebaseFirestore.instance.collection('todos').doc(_item.id);

    WriteBatch batch = FirebaseFirestore.instance.batch();
    return todoRef.collection('tasks').get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
      });
      batch.delete(todoRef);
      return batch.commit();
    });
  }

  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<TodoProvider>(context, listen: false);

    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.only(right: 10),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.close,
          color: Colors.red,
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          deleteTodo()
              .then((value) => print("Successfully deleted todo"))
              .catchError((err) {
            print("Error while deleting todo ${err}");
          });
          //FirebaseFirestore.instance.collection('todos').doc(_item.id).delete();
        }
      },
      key: ValueKey(_item.id),
      child: Container(
        margin: EdgeInsets.only(bottom: 2),
        color: Colors.blue,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: TodoTitleField(documentId: _item.id, title: _item['title']),
          trailing: Container(
              alignment: Alignment.center,
              width: 60,
              height: double.infinity,
              color: Colors.blue.shade400,
              child: Text('${_item['taskCount']}',
                  style: Theme.of(context).textTheme.headline5)),
          onTap: () {
            todos.setActiveTodoId('');
            Navigator.of(context).pushNamed(TodoTaskScreen.routeName,
                arguments: {'id': _item.id, "title": _item['title']});
          },
        ),
      ),
    );
  }
}
