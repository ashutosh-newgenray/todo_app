import 'dart:math' as math;
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;

class ThemeSettingsScreen extends StatefulWidget {
  static const routeName = "/themes";

  @override
  _ThemeSettingsScreenState createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen>
    with SingleTickerProviderStateMixin {
  double _r = -(math.pi / 2);
  double _y = 0;
  double _rotate = 0;

  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    controller.forward();
  }

  late final Animation<double> _animation = CurvedAnimation(
    parent: controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(title: Text("Theme Settings")),
        body: Center(
          child: Text("Set Global Theme"),
        ));
  }
}
