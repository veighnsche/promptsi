import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/bubbles/bubble_current_user.dart';
import 'package:prompts_game/components/bubbles/bubble_other_user.dart';
import 'package:prompts_game/components/widgets/app_future_builder.dart';
import 'package:prompts_game/components/widgets/profile_picture.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/models/app_reply.dart';
import 'package:prompts_game/store/selected_prompt.dart';
import 'package:provider/provider.dart';

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

  void _selectPrompt() {
    Provider.of<SelectedPrompt>(context, listen: false).change(widget.prompt);
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
                onTap: _selectPrompt,
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
          future: widget.prompt.myReply,
          builder: (context, AppReply? myReply) {
            if (myReply == null) {
              return Consumer<SelectedPrompt>(
                builder: (context, selected, child) {
                  if (isThisSelected(selected)) {
                    selected.prompt!.myReply.then((AppReply? myReply) {
                      if (myReply != null) {
                        Provider.of<SelectedPrompt>(context, listen: false)
                            .change(null);
                        setState(() {});
                      }
                    });
                  }

                  return child!;
                },
                child: const SizedBox.shrink(),
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
      ],
    );
  }

  bool isThisSelected(SelectedPrompt selected) {
    return selected.prompt != null &&
        selected.prompt!.reference.id == widget.prompt.reference.id;
  }
}

enum PromptReplierCardType {
  onFeed,
  onProfile,
}
