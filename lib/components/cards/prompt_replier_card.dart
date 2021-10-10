import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/bubbles/bubble_current_user.dart';
import 'package:prompts_game/components/bubbles/bubble_other_user.dart';
import 'package:prompts_game/components/widgets/app_future_builder.dart';
import 'package:prompts_game/components/widgets/profile_picture.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/models/app_reply.dart';
import 'package:prompts_game/store/selected_prompt_store.dart';
import 'package:provider/provider.dart';

class PromptReplyCard extends StatefulWidget {
  const PromptReplyCard({Key? key, required this.prompt}) : super(key: key);

  final AppPrompt prompt;

  @override
  State<PromptReplyCard> createState() => _PromptReplyCardState();
}

class _PromptReplyCardState extends State<PromptReplyCard> {
  void _selectPrompt() {
    Provider.of<SelectedPromptStore>(context, listen: false)
        .change(widget.prompt);
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
        AppFutureBuilder.skipFuture(
          future: widget.prompt.myReplyAsync,
          initialData: widget.prompt.myReply,
          builder: (context, AppReply? myReply) {
            if (myReply == null) {
              return Consumer<SelectedPromptStore>(
                builder: (context, selected, child) {
                  if (isThisSelected(selected)) {
                    selected.prompt!.myReplyAsync.then((AppReply? myReply) {
                      if (myReply != null) {
                        Provider.of<SelectedPromptStore>(context, listen: false)
                            .change(null);
                        setState(() {});
                      }
                    });
                  }

                  return const SizedBox.shrink();
                },
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Flexible(child: BubbleCurrentUser(text: myReply.reply)),
                  SizedBox(
                    height: 65,
                    width: 65,
                    child: ProfilePicture(
                      pictureUint8ListAsync: myReply.profilePictureAsync,
                      pictureUint8List: myReply.profilePicture,
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

  bool isThisSelected(SelectedPromptStore selected) {
    return selected.prompt != null &&
        selected.prompt!.reference.id == widget.prompt.reference.id;
  }
}
