import 'package:flutter/material.dart';

class Style {
  static BorderSide borderSide() {
    return BorderSide(color: const Color.fromARGB(31, 23, 23, 23));
  }

  static BorderSide borderSideBlend(Color blend) {
    final clr = Color.alphaBlend(blend, Color.fromARGB(31, 23, 23, 23));
    return BorderSide(color: clr);
  }
}
