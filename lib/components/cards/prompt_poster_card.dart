import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/bubbles/bubble_current_user.dart';
import 'package:prompts_game/components/bubbles/bubble_other_user.dart';
import 'package:prompts_game/components/scaffolds/profile_scaffold.dart';
import 'package:prompts_game/components/widgets/app_future_builder.dart';
import 'package:prompts_game/components/widgets/profile_picture.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/models/app_reply.dart';

class PromptPosterCard extends StatefulWidget {
  const PromptPosterCard({
    Key? key,
    required this.prompt,
  }) : super(key: key);

  final AppPrompt prompt;

  @override
  State<PromptPosterCard> createState() => _PromptPosterCardState();
}

class _PromptPosterCardState extends State<PromptPosterCard> {
  Future<List<String>> get ownerPicturesAsync {
    return widget.prompt.owner.then((o) => o.pictures);
  }

  void _goToProfile(AppProfile owner) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ProfileScaffold(
            profile: owner,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: BubbleCurrentUser(
            text: widget.prompt.prompt,
          ),
        ),
        AppFutureBuilder(
          future: widget.prompt.replies,
          builder: (context, List<AppReply>? replies) {
            if (replies == null) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: replies.map((AppReply reply) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: GestureDetector(
                    onTap: () {
                      print('normal tap');
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          height: 65,
                          width: 65,
                          child: ProfilePicture(
                            pictureAsync: reply.ownerPicture,
                          ),
                        ),
                        Flexible(
                          child: BubbleOtherUser(
                            text: reply.reply,
                            profileAsync: reply.owner,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
