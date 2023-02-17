import 'package:flutter/material.dart';

class ColorsinUse {
  final red = const Color.fromARGB(255, 199, 43, 32);
  final white = Colors.white;
  final tilecolor = Color.fromARGB(255, 95, 4, 4);
}

BoxDecoration newGradient() {
  return const BoxDecoration(
      gradient: LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 82, 7, 7),
      Color.fromARGB(255, 43, 4, 4),
    ],
  ));
}
