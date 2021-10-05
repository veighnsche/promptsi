import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/scaffolds/home_scaffold.dart';
import 'package:prompts_game/components/scaffolds/loading_scaffold.dart';
import 'package:prompts_game/components/scaffolds/profile_create_scaffold.dart';
import 'package:prompts_game/models/app_profile.dart';
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
    return FutureBuilder(
      initialData: _profile,
      future: ProfileApi.fetchProfile(_user!.uid),
      builder: (BuildContext context, AsyncSnapshot<AppProfile?> snapshot) {
        if (snapshot.hasError) {
          throw snapshot.error!;
          // return ErrorScaffold(message: snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return HomeScaffold(userProfile: snapshot.data!);
          } else {
            return ProfileCreateScaffold(onProfileCreated: setProfile);
          }
        }

        return const LoadingScaffold();
      },
    );
  }
}
