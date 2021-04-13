import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';
import '../screens/loading_screen.dart';
import '../widgets/todo_list_item.dart';

/// An screen to view the list of Todos
///
/// A Todo contains one or more Todo Tasks
class TodoListScreen extends StatelessWidget {
  static const routeName = "/todo-list";

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    List _items = [];
    return WillPopScope(
      onWillPop: () async {
        todoProvider.setActiveTodoId("");
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todos"),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  FirebaseFirestore.instance.collection('todos').add({
                    'id': _items.length,
                    'title': '',
                    'taskCount': 0,
                    'dateTime': DateTime.now()
                  });
                })
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('todos')
              .orderBy('dateTime', descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen();
            }
            final docs = snapshot.data.docs;
            _items = docs.map((DocumentSnapshot docSnapshot) {
              return docSnapshot;
            }).toList();

            return ListView.builder(
                itemCount: _items.length,
                itemBuilder: (ctx, i) {
                  return TodoTaskItem(_items[i]);
                });
          },
        ),
      ),
    );
  }
}
