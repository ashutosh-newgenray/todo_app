import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppFeatureItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference todos = FirebaseFirestore.instance.collection('todos');

    return StreamBuilder<QuerySnapshot>(
      stream: todos.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("");
        }

        return Container(
            alignment: Alignment.center,
            width: 60,
            height: double.infinity,
            color: Colors.grey.shade500,
            child: Text(snapshot.data!.docs.length.toString(),
                style: Theme.of(context).textTheme.headline5));
      },
    );
  }
}
