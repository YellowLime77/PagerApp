import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'main_button.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

IO.Socket socket = IO.io('https://pagerapp.onrender.com');

void main() {

  socket.on('connect', (_) {
    print('connect');
  });

  socket.on('event', (data) => print(data));
  socket.on('disconnect', (_) => print('disconnect'));
  socket.on('receivePage', (msg) => print(msg));

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
  
    socket.emit('sendPage', 'test');
  }

  void onTapCancel() {
    print('Tap cancel!');
  }
}