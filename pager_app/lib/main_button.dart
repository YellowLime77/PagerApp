import 'package:flutter/material.dart';
import 'dart:math';

class MainButton extends StatefulWidget {
  final GestureTapDownCallback onTapDown;
  final GestureTapUpCallback onTapUp;
  final GestureTapCancelCallback onTapCancel;
  final Key? key;

  MainButton({this.key, required this.onTapDown, required this.onTapUp, required this.onTapCancel}) : super(key: key);

  @override
  _MainButtonState createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> with TickerProviderStateMixin {
  late AnimationController _controller;
  double offsetVal = 8.0;
  double blurVal = 16.0;
  double spreadVal = 1.0;
  Color buttonColor = Colors.grey[300]!;
  List<VoidCallback> _animationQueue = [];
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
          _isAnimating = false;
          if (_animationQueue.isNotEmpty) {
            _animationQueue.removeAt(0)();
          }
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _enqueueAnimation(VoidCallback animation) {
    if (!_isAnimating) {
      _isAnimating = true;
      animation();
    } else {
      _animationQueue.add(animation);
    }
  }

  Future<void> animateButton({required bool isPressed}) async {
    _enqueueAnimation(() {
      setState(() {
        offsetVal = isPressed ? 0.0 : 8.0;
        blurVal = isPressed ? 0.0 : 16.0;
        spreadVal = isPressed ? 0.0 : 1.0;
        buttonColor = isPressed ? Colors.grey[350]! : Colors.grey[300]!;
      });
      if (isPressed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) async {
        widget.onTapDown(details);
        await animateButton(isPressed: true);
      },
      onTapUp: (details) async {
        widget.onTapUp(details);
        await animateButton(isPressed: false);
      },
      onTapCancel: () async {
        widget.onTapCancel();
        await animateButton(isPressed: false);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return AnimatedContainer(
              duration: const Duration(milliseconds: 30),
              height: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.75,
              width: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.75,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.75 / 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade800,
                    offset: Offset(offsetVal, offsetVal),
                    blurRadius: blurVal,
                    spreadRadius: spreadVal,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-offsetVal, -offsetVal),
                    blurRadius: blurVal,
                    spreadRadius: spreadVal,
                  ),
                ],
              ),
              child: Icon(
                Icons.notifications_active,
                size: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.3,
                color: Colors.grey[800],
                shadows: const <Shadow>[Shadow(color: Colors.white, blurRadius: 0)],
              ),
          );
        },
      ),
    );
  }
}