import 'package:flutter/material.dart';
import 'package:prompts_game/components/scaffolds/loading_scaffold.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';
import 'package:prompts_game/services/apis/profile_api.dart';

import '../forms/profile/profile_form.dart';

class ProfileEditScaffold extends StatefulWidget {
  const ProfileEditScaffold({
    Key? key,
    required this.onProfileEdited,
    required this.userProfile,
  }) : super(key: key);

  final Function(AppProfile appProfile) onProfileEdited;
  final AppProfile userProfile;

  @override
  State<StatefulWidget> createState() => _ProfileEditScaffoldState();
}

class _ProfileEditScaffoldState extends State<ProfileEditScaffold> {
  bool _isUploading = false;

  Future<void> _createProfile(AppProfile profile) async {
    setState(() {
      _isUploading = true;
    });

    ProfileApi.edit(profile).whenComplete(() {
      widget.onProfileEdited(profile);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isUploading) {
      return const LoadingScaffold();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: ProfileForm(
        isCreate: true,
        profile: widget.userProfile,
        onProfileSubmit: _createProfile,
      ),
    );
  }
}
