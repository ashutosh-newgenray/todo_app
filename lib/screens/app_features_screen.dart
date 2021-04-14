import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/screens/loading_screen.dart';
import 'package:todo_app/widgets/app_feature_item.dart';

import 'theme_settings_screen.dart';
import 'todo_list_screen.dart';

/// An Screen to view list of Todo app features
///
/// Includes link to App settings and other features.
class AppFeaturesScreen extends StatelessWidget {
  static const routeName = "/app-features";
  Future<int> getTodoCount() {
    return FirebaseFirestore.instance.collection('todos').snapshots().length;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Query features =
        FirebaseFirestore.instance.collection('features').orderBy('sequence');
    return Scaffold(
        appBar: AppBar(
          title: Text("Todo App"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: features.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen();
            }

            return new ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map item = document.data()!;
                return Container(
                  margin: EdgeInsets.only(bottom: 2),
                  color: Colors.grey.shade600,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        item['title'],
                        style: theme.textTheme.headline6!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    trailing: "/${item['route']}" == TodoListScreen.routeName
                        ? AppFeatureItem()
                        : null,
                    onTap: () => item['route'] != null
                        ? Navigator.of(context).pushNamed('/${item['route']}')
                        : {},
                  ),
                );
              }).toList(),
            );
          },
        ));
  }
}
