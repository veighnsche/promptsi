import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/forms/replies/reply_form.dart';
import 'package:prompts_game/components/scaffolds/profile_scaffold.dart';
import 'package:prompts_game/components/widgets/app_future_builder.dart';
import 'package:prompts_game/components/widgets/picture_carousel.dart';
import 'package:prompts_game/components/widgets/profile_picture.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/models/app_reply.dart';

class PromptCard extends StatefulWidget {
  const PromptCard({
    Key? key,
    required this.prompt,
    required this.type,
  }) : super(key: key);

  const PromptCard.onFeed({
    Key? key,
    required this.prompt,
    this.type = PromptCardType.onFeed,
  }) : super(key: key);

  const PromptCard.onProfile({
    Key? key,
    required this.prompt,
    this.type = PromptCardType.onProfile,
  }) : super(key: key);

  final AppPrompt prompt;
  final PromptCardType type;

  @override
  State<PromptCard> createState() => _PromptCardState();
}

class _PromptCardState extends State<PromptCard> {
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
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            AppFutureBuilder(
              future: widget.prompt.owner,
              builder: (context, AppProfile owner) {
                return Column(
                  children: [
                    if (widget.type == PromptCardType.onFeed) ...[
                      PictureCarousel.home(asyncPictures: owner.pictures),
                      const SizedBox(height: 16),
                    ],
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        Flexible(
                          child: Bubble(
                            nip: BubbleNip.leftTop,
                            color: Colors.white38,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${owner.firstName}, ${owner.age}',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'future location',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.prompt.prompt,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Transform.scale(
                          scale: 3 / 4,
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
                  ],
                );
              },
            ),
            AppFutureBuilder(
              future: widget.prompt.myReply,
              builder: (context, AppReply? myReply) {
                if (myReply == null) {
                  return ReplyForm(onReplySend: _addReply);
                }
                return ListTile(
                  title: Bubble(
                    alignment: Alignment.centerRight,
                    nip: BubbleNip.rightBottom,
                    color: Colors.blue,
                    child: Text(
                      myReply.reply,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  trailing: AppFutureBuilder(
                    future: myReply.owner,
                    builder: (context, AppProfile owner) {
                      return ProfilePicture(
                        asyncPicture: owner.picture,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum PromptCardType {
  onFeed,
  onProfile,
}
