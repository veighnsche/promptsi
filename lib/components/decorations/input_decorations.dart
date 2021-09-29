import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration outline({required String labelText}) =>
      InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );
}
