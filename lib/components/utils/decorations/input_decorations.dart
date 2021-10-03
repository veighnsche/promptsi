import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration outline({
    required String labelText,
    double borderRadius = 10,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
