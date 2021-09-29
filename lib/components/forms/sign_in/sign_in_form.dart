import 'package:flutter/material.dart';
import 'package:prompts_game/components/forms/sign_in/buttons/email_sign_in_button.dart';
import 'package:prompts_game/components/forms/sign_in/fields/email_field.dart';
import 'package:prompts_game/components/forms/sign_in/fields/password_field.dart';

class SignInForm extends StatelessWidget {
  SignInForm({Key? key, required this.onSignInWithEmail, this.isSignUp = false})
      : super(key: key);

  final Function(String email, String password) onSignInWithEmail;
  final bool isSignUp;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordRepeat = TextEditingController();

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      onSignInWithEmail(_email.text, _password.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          EmailField(controller: _email),
          const SizedBox(height: 16),
          PasswordField(
            controller: _password,
            isSignUp: isSignUp,
          ),
          if (isSignUp)
            PasswordField(
              controller: _passwordRepeat,
              repeatPassword: _password,
            ),
          const SizedBox(height: 16),
          EmailSignInButton(onSubmit: _onSubmit),
        ],
      ),
    );
  }
}
