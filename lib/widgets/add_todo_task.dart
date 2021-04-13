import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTask extends StatelessWidget {
  final String docId;
  final int id;
  String title;
  bool isComplete = false;
  final Timestamp dateTime;

  AddTask({
    required this.docId,
    required this.id,
    required this.title,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference tasks =
        FirebaseFirestore.instance.collection('todos/$docId/tasks');

    Future<void> addTask() {
      // Call the user's CollectionReference to add a new user
      return tasks
          .add({
            'id': id, // John Doe
            'title': title, // Stokes and Sons
            'isComplete': isComplete,
            'dateTime': dateTime // 42
          })
          .then((value) => print("Task Added"))
          .catchError((error) => print("Failed to add task: $error"));
    }

    return IconButton(icon: Icon(Icons.add), onPressed: addTask);
  }
}
