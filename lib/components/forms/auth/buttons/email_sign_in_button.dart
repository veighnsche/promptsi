import 'package:flutter/material.dart';

class EmailSignInButton extends StatelessWidget {
  const EmailSignInButton(
      {Key? key, required this.onSubmit, required this.isSignUp})
      : super(key: key);

  final Function() onSubmit;
  final bool isSignUp;

  String get _inOrUp {
    return isSignUp ? 'up' : 'in';
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onSubmit,
      child: Text(
        'Sign $_inOrUp with email',
        style: const TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }
}
