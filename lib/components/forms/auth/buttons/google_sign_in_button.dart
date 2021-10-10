import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prompts_game/services/apis/firebase/auth_api.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.blue,
        shape: CircleBorder(),
      ),
      child: const IconButton(
        color: Colors.white,
        icon: FaIcon(FontAwesomeIcons.google),
        onPressed: AuthApi.google,
      ),
    );
  }
}
