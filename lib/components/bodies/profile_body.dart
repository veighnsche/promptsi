import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/error_body.dart';
import 'package:prompts_game/components/forms/prompts/prompt_form.dart';
import 'package:prompts_game/components/forms/replies/reply_form.dart';
import 'package:prompts_game/components/prompts/prompt_poster.dart';
import 'package:prompts_game/components/prompts/prompt_replier.dart';
import 'package:prompts_game/components/widgets/app_stream_builder.dart';
import 'package:prompts_game/components/widgets/carousel_pictures.dart';
import 'package:prompts_game/components/widgets/profile_picture.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/models/app_reply.dart';
import 'package:prompts_game/models/store/selected_prompt_store.dart';
import 'package:prompts_game/services/apis/prompts_api.dart';
import 'package:prompts_game/services/apis/replies_api.dart';
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

  const ProfileBody.onFeed({
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

  void _onReplySend(SelectedPromptStore selectedPrompt, String reply) {
    RepliesApi(selectedPrompt.prompt!.reference)
        .create(reply)
        .then((AppReply myReply) {
      Provider.of<SelectedPromptStore>(context, listen: false)
          .change(selectedPrompt.prompt);
    });
  }

  Widget _promptsColumn(List<AppPrompt>? prompts) {
    if (prompts == null) {
      return const SizedBox.shrink();
    }
    switch (widget.type) {
      case ProfileBodyType.onMyProfile:
        return Column(
          children: prompts.map((AppPrompt prompt) {
            return PromptPoster(prompt: prompt);
          }).toList(),
        );

      case ProfileBodyType.onFeed:
        return Column(
          children: prompts.map((AppPrompt prompt) {
            return PromptReply(prompt: prompt);
          }).toList(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (onFeed)
          PhysicalModel(
            color: Colors.white,
            elevation: 2,
            child: ListTile(
              leading: ProfilePicture(
                pictureUint8ListAsync: widget.profile.profilePictureAsync,
                pictureUint8List: widget.profile.profilePicture,
              ),
              title: Text('${widget.profile.firstName}, ${widget.profile.age}'),
              subtitle: const Text('0 Km away (hardcoded)'),
            ),
          ),
        Flexible(
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                AppStreamBuilder(
                  stream: widget.profile.promptStream,
                  loader: _promptsColumn(widget.profile.prompts),
                  builder: (context, List<AppPrompt>? prompts) {
                    if (prompts == null) {
                      return const ErrorBody('No prompts yet');
                    }
                    return _promptsColumn(prompts);
                  },
                ),
                if (onMyProfile) const SizedBox(height: 16),
                CarouselPictures(picturesAsync: widget.profile.picturesAsync),
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
          Consumer<SelectedPromptStore>(
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
