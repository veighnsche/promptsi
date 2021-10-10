import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/bubbles/bubble_current_user.dart';
import 'package:prompts_game/components/bubbles/bubble_other_user.dart';
import 'package:prompts_game/components/scaffolds/profile_scaffold.dart';
import 'package:prompts_game/components/widgets/app_stream_builder.dart';
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
        AppStreamBuilder(
          stream: widget.prompt.replyStream,
          loader: RepliesColumn(replies: widget.prompt.replies),
          builder: (context, List<AppReply>? replies) {
            if (replies == null) {
              return const SizedBox.shrink();
            }

            return RepliesColumn(replies: replies);
          },
        ),
      ],
    );
  }
}

class RepliesColumn extends StatelessWidget {
  const RepliesColumn({
    Key? key,
    required this.replies,
  }) : super(key: key);

  final List<AppReply>? replies;

  @override
  Widget build(BuildContext context) {
    if (replies == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: replies!.map((AppReply reply) {
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
                    pictureUint8ListAsync: reply.profilePictureAsync,
                    pictureUint8List: reply.profilePicture,
                  ),
                ),
                Flexible(
                  child: BubbleOtherUser.onMyProfile(
                    text: reply.reply,
                    profile: reply.owner,
                    profileAsync: reply.ownerAsync,
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
