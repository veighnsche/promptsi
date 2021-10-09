import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/error_body.dart';
import 'package:prompts_game/components/cards/prompt_replier_card.dart';
import 'package:prompts_game/components/columns/prompts_poster_column.dart';
import 'package:prompts_game/components/columns/prompts_replier_column.dart';
import 'package:prompts_game/components/forms/prompts/prompt_form.dart';
import 'package:prompts_game/components/widgets/app_stream_builder.dart';
import 'package:prompts_game/components/widgets/carousel_pictures.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/services/apis/prompts_api.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    Key? key,
    required this.profile,
    required this.type,
  }) : super(key: key);

  const ProfileBody.onMyProfile({
    Key? key,
    required this.profile,
    this.type = ProfileBodyType.onMyProfile,
  }) : super(key: key);

  const ProfileBody.profile({
    Key? key,
    required this.profile,
    this.type = ProfileBodyType.onFeed,
  }) : super(key: key);

  final AppProfile profile;
  final ProfileBodyType type;

  Widget _promptsColumn(List<AppPrompt> prompts) {
    switch (type) {
      case ProfileBodyType.onMyProfile:
        return PromptsPosterColumn(prompts: prompts);

      case ProfileBodyType.onFeed:
        return PromptsReplierColumn(
          prompts: prompts,
          promptCardType: PromptReplierCardType.onFeed,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                AppStreamBuilder(
                  stream: profile.promptStream,
                  builder: (context, List<AppPrompt>? prompts) {
                    if (prompts == null) {
                      return const ErrorBody('No prompts yet');
                    }
                    return _promptsColumn(prompts);
                  },
                ),
                if (type == ProfileBodyType.onFeed)
                  ListTile(
                    title: Text('${profile.firstName}, ${profile.age}'),
                    subtitle: const Text('0 Km away (hardcoded)'),
                  ),
                if (type == ProfileBodyType.onMyProfile)
                  const SizedBox(height: 16),
                CarouselPictures(picturesAsync: profile.pictures),
              ],
            ),
          ),
        ),
        if (type == ProfileBodyType.onMyProfile)
          Padding(
            padding: const EdgeInsets.all(8),
            child: PromptForm(
              onPromptSend: PromptsApi(profile.reference).createPrompt,
            ),
          ),
      ],
    );
  }
}

enum ProfileBodyType {
  onMyProfile,
  onFeed,
}
