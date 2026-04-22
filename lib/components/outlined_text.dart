import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  final String text;
  final double? fontSize;
  const OutlinedText(this.text, {this.fontSize, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = .stroke
              ..strokeWidth = 3
              ..color = const Color.fromARGB(221, 24, 24, 24),
          ),
        ),
        Text(
          text,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}
