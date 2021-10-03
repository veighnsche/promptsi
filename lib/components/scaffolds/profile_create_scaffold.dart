import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/loading_body.dart';
import 'package:prompts_game/components/forms/profile/profile_form.dart';
import 'package:prompts_game/components/forms/prompts/choose_pre_made_prompts.dart';
import 'package:prompts_game/components/scaffolds/loading_scaffold.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/services/apis/auth_api.dart';
import 'package:prompts_game/services/apis/profile_api.dart';
import 'package:prompts_game/services/apis/prompts_api.dart';
import 'package:prompts_game/utils/string_utils.dart';

class ProfileCreateScaffold extends StatefulWidget {
  const ProfileCreateScaffold({Key? key, required this.onProfileCreated})
      : super(key: key);

  final Function(AppProfile appProfile) onProfileCreated;

  @override
  State<StatefulWidget> createState() => _ProfileCreateScaffoldState();
}

class _ProfileCreateScaffoldState extends State<ProfileCreateScaffold> {
  late AppProfile _profile;

  bool _isUploading = false;
  ProfileCreateScaffoldBodies _bodyIndex =
      ProfileCreateScaffoldBodies.profileForm;

  @override
  void initState() {
    super.initState();

    final User user = AuthApi.currentUser;
    _profile = AppProfile.create(
      userId: user.uid,
      firstName: StringUtils.getFirstWord(user.displayName),
      // DEV DEV
      age: '31',
      gender: AppGenders.man,
      interestedIn: [AppGenders.woman, AppGenders.neutral],
      // DEV DEV
    );
  }

  void _setProfile(AppProfile profile) {
    setState(() {
      _profile = profile;
      _bodyIndex = ProfileCreateScaffoldBodies.choosePreMadePrompts;
    });
  }

  Future<void> _setPrompts(List<AppPrompt> preMadePrompts) async {
    _saveProfile().whenComplete(() {
      return PromptsApi.createListFromPreMade(_profile, preMadePrompts);
    }).whenComplete(() {
      widget.onProfileCreated(_profile);
    });
  }

  Future<void> _saveProfile() {
    setState(() {
      _isUploading = true;
    });

    return ProfileApi.create(_profile).then((AppProfile? profile) {
      if (profile != null) {
        _profile = profile;
        widget.onProfileCreated(profile);
      }
    });
  }

  Widget get _body {
    switch (_bodyIndex) {
      case ProfileCreateScaffoldBodies.profileForm:
        return ProfileForm(
          isCreate: true,
          profile: _profile,
          onProfileSubmit: _setProfile,
        );

      case ProfileCreateScaffoldBodies.choosePreMadePrompts:
        return ChoosePreMadePrompts(
          onPromptsSubmit: _setPrompts,
          minimumAmount: 5,
        );

      default:
        return const LoadingBody();
    }
  }

  String get _titleText {
    switch (_bodyIndex) {
      case ProfileCreateScaffoldBodies.profileForm:
        return 'Create profile';

      case ProfileCreateScaffoldBodies.choosePreMadePrompts:
        return 'Choose your first prompts';

      default:
        return 'Loading';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isUploading) {
      return const LoadingScaffold();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleText),
      ),
      body: _body,
    );
  }
}

enum ProfileCreateScaffoldBodies {
  profileForm,
  choosePreMadePrompts,
}
