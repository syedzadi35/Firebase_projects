import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyButton extends StatefulWidget {
  String title;
  final VoidCallback onButtonpress;
  MyButton({super.key, required this.title, required this.onButtonpress});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 250,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.yellow)),
          onPressed: widget.onButtonpress,
          child: Text(widget.title)),
    );
  }
}
