import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';

/// Manage the state of Todos
class TodoProvider with ChangeNotifier {
  String? activeTaskId;
  String? activeTodoId;
  List _tasks = [];

  Stream<QuerySnapshot> fetchTodosAsStream() {
    return FirebaseFirestore.instance
        .collection('todos')
        .orderBy('dateTime', descending: true)
        .snapshots();
  }

  void setActiveTaskId(String taskId) {
    activeTaskId = taskId;
    notifyListeners();
  }

  void setActiveTodoId(String todoId) {
    activeTodoId = todoId;
    notifyListeners();
  }

  Future<dynamic> addTask(todoDocId) async {
    try {
      final tasks = FirebaseFirestore.instance
          .collection('todos')
          .doc(todoDocId)
          .collection("tasks")
          .orderBy('priority', descending: true);

      final QuerySnapshot query = await tasks.get();
      final count = query.docs.length;

      final QuerySnapshot query2 = await tasks.limit(1).get();
      final priority = query2.docs.length > 0 ? query2.docs[0]['priority'] : 0;
      var data = {
        'id': count + 1,
        'title': '',
        'isComplete': false,
        'priority': priority + 1,
        'dateTime': DateTime.now(),
        'reminder': null,
      };
      return FirebaseFirestore.instance
          .collection('todos/$todoDocId/tasks')
          .add(data)
          .then((value) {
        print(value);
        return FirebaseFirestore.instance
            .collection('todos/')
            .doc(todoDocId)
            .update({"taskCount": count + 1}).then((value) => data);
      });
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  Future<void> updateTask(todoDocId, taskDocId, data) {
    return FirebaseFirestore.instance
        .collection('todos/${todoDocId}/tasks/')
        .doc(taskDocId)
        .update(data)
        .then((value) => {print("task tile Updated")})
        .catchError((error) => print("Failed to update task: $error"));
  }

  notifyListeners();
}
