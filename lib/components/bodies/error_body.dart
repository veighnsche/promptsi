import 'package:flutter/material.dart';

class ErrorBody extends StatelessWidget {
  const ErrorBody(
    this.message, {
    Key? key,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
