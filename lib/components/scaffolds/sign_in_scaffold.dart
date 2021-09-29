import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/builders/keyboard_visibility_builder.dart';
import 'package:prompts_game/components/forms/sign_in/buttons/facebook_sign_in_button.dart';
import 'package:prompts_game/components/forms/sign_in/buttons/google_sign_in_button.dart';
import 'package:prompts_game/components/forms/sign_in/buttons/twitter_sign_in_button.dart';
import 'package:prompts_game/components/forms/sign_in/sign_in_form.dart';
import 'package:prompts_game/services/apis/auth_api.dart';

class SignInScaffold extends StatelessWidget {
  const SignInScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SignInForm(onSignInWithEmail: AuthApi.email),
              const SizedBox(height: 32),
              KeyboardVisibilityBuilder(
                child: _CredentialsSignIn(),
                builder: (context, child, isKeyboardVisible) {
                  if (child != null && !isKeyboardVisible) {
                    return child;
                  }

                  return const SizedBox(width: 0);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CredentialsSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: const [
          Expanded(child: Divider(color: Colors.black)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('or sign in with'),
          ),
          Expanded(child: Divider(color: Colors.black)),
        ]),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            GoogleSignInButton(),
            FacebookSignInButton(),
            TwitterSignInButton(),
          ],
        ),
        const SizedBox(height: 64),
      ],
    );
  }
}
