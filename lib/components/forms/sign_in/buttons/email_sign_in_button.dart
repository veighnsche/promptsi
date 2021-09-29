import 'package:flutter/material.dart';

class EmailSignInButton extends StatelessWidget {
  const EmailSignInButton({Key? key, required this.onSubmit}) : super(key: key);

  final Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onSubmit,
      child: const Text(
        'Sign in with email',
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.blue,
        ),
      ),
    );
  }
}
