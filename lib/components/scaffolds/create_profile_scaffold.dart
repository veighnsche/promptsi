import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/scaffolds/loading_scaffold.dart';
import 'package:prompts_game/models/profile_model.dart';
import 'package:prompts_game/services/apis/auth_api.dart';
import 'package:prompts_game/services/apis/profile_api.dart';
import 'package:prompts_game/utils/string_utils.dart';

import '../forms/profile/profile_form.dart';

class CreateProfileScaffold extends StatefulWidget {
  const CreateProfileScaffold({Key? key, required this.onProfileCreated})
      : super(key: key);

  final Function(AppProfile appProfile) onProfileCreated;

  @override
  State<StatefulWidget> createState() => _CreateProfileScaffoldState();
}

class _CreateProfileScaffoldState extends State<CreateProfileScaffold> {
  late AppProfile profile;

  bool _isUploading = false;

  @override
  void initState() {
    super.initState();

    final User user = AuthApi.currentUser;
    profile = AppProfile.create(
      userId: user.uid,
      firstName: StringUtils.getFirstWord(user.displayName),
    );
  }

  Future<void> _createProfile(AppProfile profile) async {
    setState(() {
      _isUploading = true;
    });

    ProfileApi.create(profile).then((AppProfile? profile) {
      if (profile != null) {
        widget.onProfileCreated(profile);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isUploading) {
      return const LoadingScaffold();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
      ),
      body: ProfileForm(
        isCreate: true,
        profile: profile,
        onProfileSubmit: _createProfile,
      ),
    );
  }
}
