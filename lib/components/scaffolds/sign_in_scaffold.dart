import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/forms/sign_in/sign_in_form.dart';
import 'package:prompts_game/services/apis/auth_api.dart';

class SignInScaffold extends StatelessWidget {
  const SignInScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("You're not logged in yet")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SignInForm(onSignInWithEmail: AuthApi.email),
              const ElevatedButton(
                child: Text('Log in with Google'),
                onPressed: AuthApi.google,
              )
            ],
          ),
        ),
      ),
    );
  }
}
