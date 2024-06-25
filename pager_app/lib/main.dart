import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'main_button.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    socket = IO.io('https://pagerapp.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('connected');
    });

    socket.on('event', (data) => print(data));
    socket.on('disconnect', (_) => print('disconnected'));

    socket.on('page', (data) {
      print(data);
    });
  }

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
  
    socket.emit('page', 'test');
  }

  void onTapCancel() {
    print('Tap cancel!');
  }
}