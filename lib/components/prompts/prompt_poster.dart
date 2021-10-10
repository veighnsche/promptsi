import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/bubbles/bubble_current_user.dart';
import 'package:prompts_game/components/bubbles/bubble_other_user.dart';
import 'package:prompts_game/components/scaffolds/profile_scaffold.dart';
import 'package:prompts_game/components/widgets/app_stream_builder.dart';
import 'package:prompts_game/components/widgets/profile_picture.dart';
import 'package:prompts_game/components/widgets/reactions.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/models/app_reply.dart';

class PromptPoster extends StatelessWidget {
  const PromptPoster({
    Key? key,
    required this.prompt,
  }) : super(key: key);

  final AppPrompt prompt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: BubbleCurrentUser(
            text: prompt.prompt,
          ),
        ),
        AppStreamBuilder(
          stream: prompt.replyStream,
          loader: RepliesColumn(replies: prompt.replies),
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
          child: ReplierRow(reply: reply),
        );
      }).toList(),
    );
  }
}

class ReplierRow extends StatefulWidget {
  const ReplierRow({Key? key, required this.reply}) : super(key: key);

  final AppReply reply;

  @override
  State<ReplierRow> createState() => _ReplierRowState();
}

class _ReplierRowState extends State<ReplierRow> {
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
    return Row(
      children: [
        SizedBox(
          height: 65,
          width: 65,
          child: GestureDetector(
            onTap: () => _goToProfile(widget.reply.owner!),
            child: ProfilePicture(
              pictureUint8ListAsync: widget.reply.profilePictureAsync,
              pictureUint8List: widget.reply.profilePicture,
            ),
          ),
        ),
        Flexible(
          child: BubbleOtherUser.onMyProfile(
            text: widget.reply.reply,
            profile: widget.reply.owner,
            profileAsync: widget.reply.ownerAsync,
          ),
        ),
        Reactions(
          reaction: widget.reply.reaction,
          onReact: widget.reply.react,
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
