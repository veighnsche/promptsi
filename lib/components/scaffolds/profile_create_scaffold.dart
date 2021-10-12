import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/forms/profile/profile_form.dart';
import 'package:prompts_game/components/scaffolds/loading_scaffold.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';
import 'package:prompts_game/services/apis/firebase/auth_api.dart';
import 'package:prompts_game/services/apis/profile_api.dart';
import 'package:prompts_game/utils/string_utils.dart';

class ProfileCreateScaffold extends StatefulWidget {
  const ProfileCreateScaffold({Key? key, required this.onProfileCreated})
      : super(key: key);

  final Function(AppProfile appProfile) onProfileCreated;

  @override
  State<StatefulWidget> createState() => _ProfileCreateScaffoldState();
}

class _ProfileCreateScaffoldState extends State<ProfileCreateScaffold> {
  final User user = AuthApi.currentUser;

  bool _isUploading = false;

  Future<void> _saveProfile(AppProfile profile) {
    setState(() {
      _isUploading = true;
    });

    return ProfileApi.create(user.uid, profile).then((AppProfile profileRes) {
      widget.onProfileCreated(profileRes);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isUploading) {
      return const LoadingScaffold();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create profile'),
      ),
      body: ProfileForm(
        isCreate: true,
        profile: AppProfile.create(
          firstName: StringUtils.getFirstWord(user.displayName),
          // DEV DEV
          // age: '31',
          // gender: AppGenders.man,
          // interestedIn: [AppGenders.woman, AppGenders.neutral],
          // DEV DEV
        ),
        onProfileSubmit: _saveProfile,
      ),
    );
  }
}
