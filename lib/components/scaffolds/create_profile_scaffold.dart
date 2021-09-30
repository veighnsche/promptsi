import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prompts_game/components/scaffolds/loading_scaffold.dart';
import 'package:prompts_game/models/profile_model.dart';
import 'package:prompts_game/services/apis/profile_api.dart';
import 'package:prompts_game/utils/string_utils.dart';

import '../forms/profile/profile_form.dart';

class CreateProfileScaffold extends StatefulWidget {
  const CreateProfileScaffold({Key? key, required this.onProfileCreated})
      : super(key: key);

  final Function(ProfileModel appProfile) onProfileCreated;

  @override
  State<StatefulWidget> createState() => _CreateProfileScaffoldState();
}

class _CreateProfileScaffoldState extends State<CreateProfileScaffold> {
  final User _user = FirebaseAuth.instance.currentUser as User;
  late ProfileModel profile;

  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    profile = ProfileModel.create(
      userId: _user.uid,
      firstName: StringUtils.getFirstWord(_user.displayName),
    );
  }

  Future<void> _createProfile(
    ProfileModel profile,
    XFile? profilePicture,
  ) async {
    if (profilePicture != null) {
      setState(() {
        _isUploading = true;
      });

      ProfileApi.create(profile, profilePicture).then((ProfileModel? profile) {
        if (profile != null) {
          widget.onProfileCreated(profile);
        }
      });
    }
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
        profile: profile,
        onProfileSubmit: _createProfile,
      ),
    );
  }
}
