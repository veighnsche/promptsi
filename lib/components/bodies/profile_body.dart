import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/loading_body.dart';
import 'package:prompts_game/components/cards/prompt_replier_card.dart';
import 'package:prompts_game/components/columns/prompts_poster_column.dart';
import 'package:prompts_game/components/columns/prompts_replier_column.dart';
import 'package:prompts_game/components/widgets/picture_carousel.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_prompt.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    Key? key,
    required this.profile,
    required this.type,
  }) : super(key: key);

  const ProfileBody.currentUser({
    Key? key,
    required this.profile,
    this.type = AppProfileType.currentUser,
  }) : super(key: key);

  const ProfileBody.profile({
    Key? key,
    required this.profile,
    this.type = AppProfileType.profile,
  }) : super(key: key);

  final AppProfile profile;
  final AppProfileType type;

  Widget _promptsColumn(List<AppPrompt> prompts) {
    switch (type) {
      case AppProfileType.currentUser:
        return PromptsPosterColumn(
          profile: profile,
          prompts: prompts,
        );

      case AppProfileType.profile:
        return PromptsReplierColumn(
          prompts: prompts,
          promptCardType: PromptReplierCardType.onProfile,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        PictureCarousel.profile(picturesAsync: profile.pictures),
        const SizedBox(height: 16),
        FutureBuilder(
          future: profile.prompts,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<AppPrompt>?> snapshot,
          ) {
            if (snapshot.hasError) {
              throw snapshot.error!;
              // return Text(snapshot.error.toString());
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return _promptsColumn(snapshot.data!);
            }

            return const LoadingBody();
          },
        ),
      ],
    );
  }
}

enum AppProfileType {
  currentUser,
  profile,
}
