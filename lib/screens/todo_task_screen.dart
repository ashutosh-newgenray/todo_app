import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/todo_provider.dart';
import '../widgets/reorderable_task_list.dart';
import 'loading_screen.dart';

class TodoTaskScreen extends StatelessWidget {
  static const routeName = "/todo-tasks";

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)!.settings.arguments as Map;
    final todoDocId = args['id'];
    List _tasks = [];
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        todoProvider.setActiveTaskId("");
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(args['title']),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  todoProvider
                      .addTask(todoDocId)
                      .then((value) => print('Added New Task'))
                      .catchError(
                          (err) => print('Error in adding new task $err'));
                })
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('todos/${args['id']}/tasks')
              .orderBy('priority', descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen();
            }

            final docs = snapshot.data.docs;
            _tasks = docs.map((DocumentSnapshot document) {
              return document;
            }).toList();

            final List _sortedList = [
              ..._tasks.where((item) => !item.data()['isComplete']),
              ..._tasks.where((item) => item.data()['isComplete'])
            ];
            return ReorderableTaskList(
                todoDocId: todoDocId, tasks: _sortedList);
          },
        ),
      ),
    );
  }
}
