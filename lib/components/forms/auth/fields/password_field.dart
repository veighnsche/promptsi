import 'package:flutter/material.dart';
import 'package:prompts_game/components/decorations/input_decorations.dart';

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

  bool get _isRepeatPassword {
    return repeatPassword != null;
  }

  String? _validator(value) {
    if (_isRepeatPassword) {
      // check if password and repeat password are the same
      if (value != repeatPassword!.text) {
        return 'Passwords do not match';
      }
    } else {
      if (value!.isEmpty) {
        return 'Please enter your password';
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
      decoration: InputDecorations.outline(
        labelText: _isRepeatPassword ? 'Repeat password' : 'Password',
      ),
      controller: controller,
      validator: _validator,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
    );
  }
}
