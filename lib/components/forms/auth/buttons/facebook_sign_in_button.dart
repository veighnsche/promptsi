import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prompts_game/services/apis/firebase/auth_api.dart';

class FacebookSignInButton extends StatelessWidget {
  const FacebookSignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.blue,
        shape: CircleBorder(),
      ),
      child: const IconButton(
        color: Colors.white,
        icon: FaIcon(FontAwesomeIcons.facebook),
        onPressed: AuthApi.google,
      ),
    );
  }
}
