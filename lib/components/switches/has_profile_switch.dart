import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/scaffolds/home_scaffold.dart';
import 'package:prompts_game/components/scaffolds/profile_create_scaffold.dart';
import 'package:prompts_game/components/builders/app_future_builder.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';
import 'package:prompts_game/services/apis/profile_api.dart';

class HasProfileSwitch extends StatefulWidget {
  const HasProfileSwitch({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HasProfileSwitchState();
}

class _HasProfileSwitchState extends State<HasProfileSwitch> {
  final User? _user = FirebaseAuth.instance.currentUser;
  AppProfile? _profile;

  void setProfile(AppProfile appProfile) {
    setState(() {
      _profile = appProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppFutureBuilder.skipFuture(
      future: ProfileApi.fetchProfile(_user!.uid),
      initialData: _profile,
      builder: (context, AppProfile? profile) {
        if (profile == null) {
          return ProfileCreateScaffold(onProfileCreated: setProfile);
        } else {
          return HomeScaffold(userProfile: profile);
        }
      },
    );
  }
}
