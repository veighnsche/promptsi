import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prompts_game/components/scaffolds/sign_in_scaffold.dart';
import 'package:prompts_game/components/switches/has_profile_switch.dart';
import 'package:prompts_game/services/apis/firebase/auth_api.dart';

class IsSignedInSwitch extends StatefulWidget {
  const IsSignedInSwitch({Key? key}) : super(key: key);

  @override
  State<IsSignedInSwitch> createState() => _IsSignedInSwitchState();
}

class _IsSignedInSwitchState extends State<IsSignedInSwitch> {
  bool _isSignedIn = AuthApi.isSignedIn;

  late StreamSubscription _authStateChanges;

  void _setSignedIn(bool isSignedIn) {
    if (_isSignedIn != isSignedIn) {
      setState(() {
        _isSignedIn = isSignedIn;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _authStateChanges = AuthApi.isSingedInStream(_setSignedIn);
  }

  @override
  void dispose() {
    super.dispose();
    _authStateChanges.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_isSignedIn) {
      return const HasProfileSwitch();
    }
    return const SignInScaffold();
  }
}
