import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/scaffolds/create_profile_scaffold.dart';
import 'package:prompts_game/components/scaffolds/error_scaffold.dart';
import 'package:prompts_game/components/scaffolds/home_scaffold.dart';
import 'package:prompts_game/components/scaffolds/loading_scaffold.dart';
import 'package:prompts_game/models/profile_model.dart';
import 'package:prompts_game/services/apis/profile_api.dart';

class HasProfileRouter extends StatefulWidget {
  const HasProfileRouter({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HasProfileRouterState();
}

class _HasProfileRouterState extends State<HasProfileRouter> {
  final User _user = FirebaseAuth.instance.currentUser as User;
  ProfileModel? _profile;

  void setProfile(ProfileModel appProfile) {
    setState(() {
      _profile = appProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_profile != null) {
      return HomeScaffold(
        userProfile: _profile!,
      );
    }
    return FutureBuilder(
      future: ProfileApi.has(_user.uid),
      builder: (BuildContext context, AsyncSnapshot<ProfileModel?> snapshot) {
        if (snapshot.hasError) {
          return ErrorScaffold(message: snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return HomeScaffold(
              userProfile: snapshot.data!,
            );
          } else {
            return CreateProfileScaffold(
              onProfileCreated: setProfile,
            );
          }
        }

        return const LoadingScaffold();
      },
    );
  }
}
