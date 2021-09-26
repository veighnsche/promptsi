import 'package:flutter/material.dart';

class ErrorScaffold extends StatelessWidget {
  const ErrorScaffold({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text(message)),
    );
  }
}