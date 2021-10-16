import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/profile_body.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';
import 'package:prompts_game/models/store/selected_prompt_store.dart';
import 'package:provider/provider.dart';

class ProfileOtherBody extends StatelessWidget {
  const ProfileOtherBody({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final AppProfile profile;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectedPromptStore(),
      child: ProfileBody.onFeed(profile: profile),
    );
  }
}
