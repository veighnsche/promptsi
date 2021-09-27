import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/interfaces/app_profile.dart';
import 'package:prompts_game/scaffolds/create_profile_scaffold.dart';
import 'package:prompts_game/scaffolds/error_scaffold.dart';
import 'package:prompts_game/scaffolds/home_scaffold.dart';
import 'package:prompts_game/scaffolds/loading_scaffold.dart';

class HasProfileRouter extends StatefulWidget {
  const HasProfileRouter({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HasProfileRouterState();
}

class _HasProfileRouterState extends State<HasProfileRouter> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  AppProfile? _userProfile;

  @override
  Widget build(BuildContext context) {
    if (_userProfile != null) {
      return HomeScaffold(userProfile: _userProfile!);
    }

    return StreamBuilder(
      stream: AppProfile.firestoreRef.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const ErrorScaffold(message: 'Error loading your profile');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScaffold();
        }

        Iterable<AppProfile> profiles = snapshot.data!.docs.map((d) => d.data() as AppProfile);
        List<AppProfile> filtered = profiles.where((d) => d.email == _currentUser!.email).toList();

        if (filtered.isEmpty) {
          return const CreateProfileScaffold();
        }

        if (filtered.isNotEmpty) {
          print(filtered.elementAt(0).email);
          Future.delayed(Duration.zero, () async {
            setState(() {
              _userProfile = filtered.elementAt(0);
            });
          });
        }

        return const LoadingScaffold();
      },
    );
  }
}
