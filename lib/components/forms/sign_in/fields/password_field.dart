import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    Key? key,
    required this.controller,
    this.repeatPassword,
    this.isSignUp = false,
  }) : super(key: key);

  final TextEditingController controller;
  final TextEditingController? repeatPassword;
  final bool isSignUp;

  String? _validator(value) {
    if (value!.isEmpty) {
      return 'Please enter your password';
    }

    if (repeatPassword != null) {
      // check if password and repeat password are the same
      if (value != repeatPassword!.text) {
        return 'Passwords do not match';
      }
    }
    
    if (isSignUp) {
      // has to be at least 6 characters
      if (value!.length < 6) {
        return 'Password must be at least 6 characters';
      }
      // has to be a number
      if (!value!.contains(RegExp(r'[0-9]'))) {
        return 'Password must contain a number';
      }
      // has to be a lowercase letter
      if (!value!.contains(RegExp(r'[a-z]'))) {
        return 'Password must contain a lowercase letter';
      }
      // has to be an uppercase letter
      if (!value!.contains(RegExp(r'[A-Z]'))) {
        return 'Password must contain an uppercase letter';
      }
      // has to be a special character
      if (!value!.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        return 'Password must contain a special character';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Password',
      ),
      controller: controller,
      validator: _validator,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
    );
  }
}
