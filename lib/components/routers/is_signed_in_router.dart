import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/routers/has_profile_router.dart';
import 'package:prompts_game/components/scaffolds/sign_in_scaffold.dart';

class IsSignedInRouter extends StatefulWidget {
  const IsSignedInRouter({Key? key}) : super(key: key);

  @override
  State<IsSignedInRouter> createState() => _IsSignedInRouterState();
}

class _IsSignedInRouterState extends State<IsSignedInRouter> {
  bool _isSignedIn = FirebaseAuth.instance.currentUser != null;

  late StreamSubscription _authStateChanges;

  void setSignedIn(bool isSignedIn) {
    if (_isSignedIn != isSignedIn) {
      setState(() {
        _isSignedIn = isSignedIn;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _authStateChanges =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setSignedIn(user != null);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _authStateChanges.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_isSignedIn) {
      return const HasProfileRouter();
    }
    return SignInScaffold();
  }
}
