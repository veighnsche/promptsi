import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/builders/keyboard_visibility_builder.dart';
import 'package:prompts_game/components/forms/auth/buttons/facebook_sign_in_button.dart';
import 'package:prompts_game/components/forms/auth/buttons/google_sign_in_button.dart';
import 'package:prompts_game/components/forms/auth/buttons/twitter_sign_in_button.dart';
import 'package:prompts_game/components/forms/auth/sign_in_form.dart';
import 'package:prompts_game/components/widgets/divider_text.dart';
import 'package:prompts_game/services/apis/auth_api.dart';

class SignInScaffold extends StatefulWidget {
  const SignInScaffold({Key? key}) : super(key: key);

  @override
  State<SignInScaffold> createState() => _SignInScaffoldState();
}

class _SignInScaffoldState extends State<SignInScaffold> {
  bool _isSignUp = false;

  void _toggleSignUp() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in to Prompts!')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _toggleSignUp,
                    child: Column(
                      children: [
                        Text(
                          _isSignUp
                              ? 'Already have an account?'
                              : 'Don\'t have an account?',
                        ),
                        Text(
                          _isSignUp ? 'Sign in instead!' : 'Sign up instead!',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SignInForm(
                    onSignInWithEmail:
                        _isSignUp ? AuthApi.signUp : AuthApi.email,
                    isSignUp: _isSignUp,
                  ),
                  const SizedBox(height: 32),
                  KeyboardVisibilityBuilder(
                    builder: (context, child, isKeyboardVisible) {
                      if (child != null && !isKeyboardVisible) {
                        return child;
                      }
                      return const SizedBox.shrink();
                    },
                    child: Column(
                      children: [
                        DividerText(
                          _isSignUp ? 'or sign up with' : 'or sign in with',
                        ),
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
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
