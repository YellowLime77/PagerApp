import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'main_button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My First Flutter App',
      home: Scaffold(
        body: Center(
          child: MainButton(
            onTapDown: onTapDown,
            onTapUp: onTapUp,
            onTapCancel: onTapCancel,
          ),
        ),
        backgroundColor: Colors.grey[300],
      ),
    );
  }

  void onTapDown(TapDownDetails details) {
    print('Tap down!');
  }

  void onTapUp(TapUpDetails details) {
    print('Tap up!');
  }

  void onTapCancel() {
    print('Tap cancel!');
  }
}