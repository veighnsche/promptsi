import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/bubbles/bubble_current_user.dart';
import 'package:prompts_game/components/bubbles/bubble_other_user.dart';
import 'package:prompts_game/components/builders/app_future_builder.dart';
import 'package:prompts_game/components/builders/app_stream_builder.dart';
import 'package:prompts_game/components/widgets/profile_picture.dart';
import 'package:prompts_game/components/widgets/reactions.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';
import 'package:prompts_game/models/documents/app_prompt/app_prompt.dart';
import 'package:prompts_game/models/documents/app_reply/app_reply.dart';
import 'package:prompts_game/services/apis/firebase/auth_api.dart';
import 'package:prompts_game/utils/navigator_utils.dart';

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
        BubbleCurrentUser.onMyProfile(
          text: prompt.prompt,
          isRePrompt: prompt.madeById != AuthApi.uid,
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
  @override
  Widget build(BuildContext context) {
    return AppFutureBuilder.skipFuture(
        future: widget.reply.ownerAsync,
        initialData: widget.reply.owner,
        builder: (context, AppProfile profile) {
          return Row(
            children: [
              SizedBox(
                height: 65,
                width: 65,
                child: GestureDetector(
                  onTap: () => NavigatorUtils.goToProfile(context, profile),
                  child: ProfilePicture(profile: profile),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () => {
                    profile.chatAsync.then((AppChat? chat) {
                      NavigatorUtils.openChat(context,
                          profile: profile, chat: chat);
                    })
                  },
                  child: BubbleOtherUser.onMyProfile(
                    text: widget.reply.reply,
                    profile: profile,
                  ),
                ),
              ),
              Reactions(
                reaction: widget.reply.reaction,
                onReact: widget.reply.react,
              ),
              const SizedBox(width: 16),
            ],
          );
        });
  }
}
