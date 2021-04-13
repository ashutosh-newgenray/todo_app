import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTodo extends StatelessWidget {
  final String title;
  final Timestamp dateTime;

  AddTodo(this.title, this.dateTime);

  @override
  Widget build(BuildContext context) {
    CollectionReference todos = FirebaseFirestore.instance.collection('todos');

    Future<void> addTodo() {
      return todos
          .add({
            'title': title,
            'dateTime': DateTime.now(),
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return IconButton(icon: Icon(Icons.add), onPressed: addTodo);
  }
}
