import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/screens/app_features_screen.dart';

/// Landing screen with welcome text
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AppFeaturesScreen.routeName),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RichText(
                  text: TextSpan(
                text: "Welcome to ",
                style: Theme.of(context).textTheme.headline4,
                children: [
                  TextSpan(
                    text: 'Clear',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              )),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: RichText(
                  text: TextSpan(
                      text: 'Tap or swipe ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              Theme.of(context).textTheme.headline6!.fontSize,
                          color: Theme.of(context).textTheme.headline6!.color),
                      children: [
                        TextSpan(
                            text: "to begin",
                            style: Theme.of(context).textTheme.headline6)
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
