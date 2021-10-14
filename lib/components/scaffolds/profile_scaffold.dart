import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/profile_other_body.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';

class ProfileScaffold extends StatelessWidget {
  const ProfileScaffold({Key? key, required this.profile}) : super(key: key);

  final AppProfile profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(profile.firstName),

      ),
      body: ProfileOtherBody(profile: profile),
    );
  }
}
