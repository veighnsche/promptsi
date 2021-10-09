import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/error_body.dart';
import 'package:prompts_game/components/cards/prompt_replier_card.dart';
import 'package:prompts_game/components/columns/prompts_poster_column.dart';
import 'package:prompts_game/components/columns/prompts_replier_column.dart';
import 'package:prompts_game/components/forms/prompts/prompt_form.dart';
import 'package:prompts_game/components/forms/replies/reply_form.dart';
import 'package:prompts_game/components/widgets/app_stream_builder.dart';
import 'package:prompts_game/components/widgets/carousel_pictures.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/models/app_reply.dart';
import 'package:prompts_game/services/apis/prompts_api.dart';
import 'package:prompts_game/services/apis/reply_api.dart';
import 'package:prompts_game/store/selected_prompt.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatefulWidget {
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

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  bool get onFeed {
    return widget.type == ProfileBodyType.onFeed;
  }

  bool get onMyProfile {
    return widget.type == ProfileBodyType.onMyProfile;
  }

  void _onReplySend(SelectedPrompt selectedPrompt, String reply) {
    ReplyApi(selectedPrompt.prompt!.reference).create(reply).then(
          (AppReply myReply) {
        Provider.of<SelectedPrompt>(context, listen: false).change(
          selectedPrompt.prompt!..setMyReply(myReply),
        );
      },
    );
  }

  Widget _promptsColumn(List<AppPrompt> prompts) {
    switch (widget.type) {
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
                  stream: widget.profile.promptStream,
                  builder: (context, List<AppPrompt>? prompts) {
                    if (prompts == null) {
                      return const ErrorBody('No prompts yet');
                    }
                    return _promptsColumn(prompts);
                  },
                ),
                if (onFeed)
                  ListTile(
                    title: Text(
                        '${widget.profile.firstName}, ${widget.profile.age}'),
                    subtitle: const Text('0 Km away (hardcoded)'),
                  ),
                if (onMyProfile) const SizedBox(height: 16),
                CarouselPictures(picturesAsync: widget.profile.pictures),
              ],
            ),
          ),
        ),
        if (onMyProfile)
          Padding(
            padding: const EdgeInsets.all(8),
            child: PromptForm(
              onPromptSend: PromptsApi(widget.profile.reference).createPrompt,
            ),
          ),
        if (onFeed)
          Consumer<SelectedPrompt>(
            builder: (context, selected, child) {
              if (selected.prompt == null || selected.hasMyReply) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.all(8),
                child: ReplyForm(
                  selectedPrompt: selected.prompt!,
                  onReplySend: (String reply) {
                    _onReplySend(selected, reply);
                  },
                ),
              );
            },
          )
      ],
    );
  }
}

enum ProfileBodyType {
  onMyProfile,
  onFeed,
}
