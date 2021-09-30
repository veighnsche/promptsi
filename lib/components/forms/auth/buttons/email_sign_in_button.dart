import 'package:flutter/material.dart';

class EmailSignInButton extends StatelessWidget {
  const EmailSignInButton({Key? key, required this.onSubmit, required this.isSignUp}) : super(key: key);

  final Function() onSubmit;
  final bool isSignUp;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onSubmit,
      child: Text(
        isSignUp ? 'Sign up with email' :'Sign in with email',
        style: const TextStyle(
          fontSize: 18.0,
          color: Colors.blue,
        ),
      ),
    );
  }
}
