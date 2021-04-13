import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/screens/newsletter_screen.dart';
import 'package:todo_app/screens/todo_task_screen.dart';

import 'screens/home_screen.dart';
import 'screens/app_features_screen.dart';
import 'screens/todo_list_screen.dart';
import 'screens/theme_settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget with RouteAware {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(initialPage: 0);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TodoProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App Demo',
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark().copyWith(
            textTheme: TextTheme(
              headline4: TextStyle(color: Colors.black87),
              headline6: TextStyle(color: Colors.black87),
            ),
            iconTheme: IconThemeData(color: Colors.black)),
        theme: ThemeData(
          fontFamily: 'Roboto',
          textTheme: TextTheme(
            headline4: TextStyle(color: Colors.black87),
            headline6: TextStyle(color: Colors.black87),
          ),
        ),
        home: FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              // Check for errors
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              // Once complete, show your application
              if (snapshot.connectionState == ConnectionState.done) {
                return PageView(controller: pageController, children: [
                  HomeScreen(),
                  AppFeaturesScreen(),
                  TodoListScreen(),
                ]);
              }

              // Otherwise, show something whilst waiting for initialization to complete
              return Text("Loading....");
            }),
        routes: {
          AppFeaturesScreen.routeName: (context) => AppFeaturesScreen(),
          TodoListScreen.routeName: (context) => TodoListScreen(),
          TodoTaskScreen.routeName: (context) => TodoTaskScreen(),
          ThemeSettingsScreen.routeName: (context) => ThemeSettingsScreen(),
          NewsletterScreen.routeName: (context) => NewsletterScreen()
        },
      ),
    );
  }
}
