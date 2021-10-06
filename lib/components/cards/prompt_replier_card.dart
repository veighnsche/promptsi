import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/bubbles/bubble_current_user.dart';
import 'package:prompts_game/components/bubbles/bubble_other_user.dart';
import 'package:prompts_game/components/forms/replies/reply_form.dart';
import 'package:prompts_game/components/scaffolds/profile_scaffold.dart';
import 'package:prompts_game/components/widgets/app_future_builder.dart';
import 'package:prompts_game/components/widgets/picture_carousel.dart';
import 'package:prompts_game/components/widgets/profile_picture.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/models/app_reply.dart';

class PromptReplyCard extends StatefulWidget {
  const PromptReplyCard({
    Key? key,
    required this.prompt,
    required this.type,
  }) : super(key: key);

  const PromptReplyCard.onFeed({
    Key? key,
    required this.prompt,
    this.type = PromptReplierCardType.onFeed,
  }) : super(key: key);

  const PromptReplyCard.onProfile({
    Key? key,
    required this.prompt,
    this.type = PromptReplierCardType.onProfile,
  }) : super(key: key);

  final AppPrompt prompt;
  final PromptReplierCardType type;

  @override
  State<PromptReplyCard> createState() => _PromptReplyCardState();
}

class _PromptReplyCardState extends State<PromptReplyCard> {
  bool get isOnFeed {
    return widget.type == PromptReplierCardType.onFeed;
  }

  bool get isOnProfile {
    return widget.type == PromptReplierCardType.onProfile;
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

  void _addReply(String reply) async {
    await widget.prompt.addReply(reply);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isOnFeed) ...[
          const SizedBox(height: 16),
          PictureCarousel.home(picturesAsync: widget.prompt.ownerPictures),
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            const SizedBox(width: 16),
            Flexible(
              child: BubbleOtherUser(
                text: widget.prompt.prompt,
                profileAsync: widget.prompt.owner,
              ),
            ),
            Transform.scale(
              scale: 6 / 8,
              child: IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // todo: reprompt
                  print('reprompt this!');
                },
              ),
            ),
          ],
        ),
        AppFutureBuilder(
          future: widget.prompt.myReply,
          builder: (context, AppReply? myReply) {
            if (myReply == null) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ReplyForm(onReplySend: _addReply),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Flexible(
                    child: BubbleCurrentUser(
                      text: myReply.reply,
                    ),
                  ),
                  SizedBox(
                    height: 65,
                    width: 65,
                    child: ProfilePicture(
                      pictureAsync: myReply.ownerPicture,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Container(height: 16, color: Colors.blueGrey),
      ],
    );
  }
}

enum PromptReplierCardType {
  onFeed,
  onProfile,
}
