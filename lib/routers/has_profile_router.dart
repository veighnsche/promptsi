import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final CollectionReference _profiles = FirebaseFirestore.instance
      .collection('profiles');


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _profiles.where('email', isEqualTo: _currentUser?.email).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const ErrorScaffold(message: 'Error loading your profile');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          print(snapshot);
          if (snapshot.data!.docs.isNotEmpty) {
            return const HomeScaffold();
          }
          return CreateProfileScaffold();
        }

        return const LoadingScaffold();
      },
    );
  }

}
