import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/bubbles/bubble_current_user.dart';
import 'package:prompts_game/components/bubbles/bubble_other_user.dart';
import 'package:prompts_game/components/widgets/app_stream_builder.dart';
import 'package:prompts_game/components/widgets/profile_picture.dart';
import 'package:prompts_game/components/widgets/reactions.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/models/app_reply.dart';
import 'package:prompts_game/models/store/selected_prompt_store.dart';
import 'package:provider/provider.dart';

class PromptReply extends StatefulWidget {
  const PromptReply({Key? key, required this.prompt}) : super(key: key);

  final AppPrompt prompt;

  @override
  State<PromptReply> createState() => _PromptReplyState();
}

class _PromptReplyState extends State<PromptReply> {
  bool isThisSelected(SelectedPromptStore selected) {
    return selected.prompt != null &&
        selected.prompt!.reference.id == widget.prompt.reference.id;
  }

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
                child: BubbleOtherUser.onFeed(text: widget.prompt.prompt),
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
                  widget.prompt.rePrompt().whenComplete(() {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('You prompted: ${widget.prompt.prompt}'),
                    ));
                  });
                },
              ),
            ),
          ],
        ),
        AppStreamBuilder(
          stream: widget.prompt.myReplyStream,
          builder: (context, AppReply? myReply) {
            if (myReply == null) {
              return Consumer<SelectedPromptStore>(
                builder: (context, selected, child) {
                  if (isThisSelected(selected) && selected.hasMyReply) {
                    Provider.of<SelectedPromptStore>(context, listen: false)
                        .change(null);
                  }
                  return const SizedBox.shrink();
                },
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 16),
                Reactions.disabled(reaction: myReply.reaction),
                BubbleCurrentUser(text: myReply.reply),
                SizedBox(
                  height: 65,
                  width: 65,
                  child: ProfilePicture(
                    pictureUint8ListAsync: myReply.profilePictureAsync,
                    pictureUint8List: myReply.profilePicture,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
