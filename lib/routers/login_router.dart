import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/scaffolds/home_scaffold.dart';
import 'package:prompts_game/scaffolds/sign_in_scaffold.dart';

class LoginRouter extends StatefulWidget {
  const LoginRouter({Key? key}) : super(key: key);

  @override
  State<LoginRouter> createState() => _LoginRouterState();
}

class _LoginRouterState extends State<LoginRouter> {
  bool _isSignedIn = FirebaseAuth.instance.currentUser != null;

  void setSignedIn(bool isSignedIn) {
    if (_isSignedIn != isSignedIn) {
      setState(() {
        _isSignedIn = isSignedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setSignedIn(user != null);
    });

    if (_isSignedIn) {
      return const HomeScaffold();
    }
    return SignInScaffold();
  }
}
