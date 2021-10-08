import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/bubbles/bubble_current_user.dart';
import 'package:prompts_game/components/bubbles/bubble_other_user.dart';
import 'package:prompts_game/components/forms/replies/reply_form.dart';
import 'package:prompts_game/components/scaffolds/profile_scaffold.dart';
import 'package:prompts_game/components/widgets/app_future_builder.dart';
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

  bool _isOpen = false;
  AppReply? _myReply;

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

  void _toggleOpen() {
    if (_myReply == null) {
      setState(() {
        _isOpen = !_isOpen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 16),
            Flexible(
              child: GestureDetector(
                onTap: _toggleOpen,
                child: BubbleOtherUser.onFeed(
                  text: widget.prompt.prompt,
                ),
              ),
            ),
            Transform.scale(
              scale: 6 / 8,
              child: IconButton(
                icon: const Icon(
                  Icons.share,
                  color: Colors.black26,
                ),
                onPressed: () {
                  // todo: reprompt
                  print('reprompt this!');
                },
              ),
            ),
          ],
        ),
        AppFutureBuilder(
          future: widget.prompt.myReply.then((AppReply? myReply) {
            _myReply = myReply;
            return myReply;
          }),
          builder: (context, AppReply? myReply) {
            if (myReply == null) {
              if (_isOpen) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ReplyForm(onReplySend: _addReply),
                );
              } else {
                return const SizedBox.shrink();
              }
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
      ],
    );
  }
}

enum PromptReplierCardType {
  onFeed,
  onProfile,
}
