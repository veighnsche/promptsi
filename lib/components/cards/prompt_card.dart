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
                    if (widget.type == PromptCardType.onFeed)
                      PictureCarousel.home(asyncPictures: owner.pictures),
                    ListTile(
                      onTap: () => _goToProfile(owner),
                      title: Text('${owner.firstName}, ${owner.age}'),
                      subtitle: const Text('future location'),
                    ),
                    ListTile(
                      leading: ProfilePicture(
                        asyncPicture: owner.picture,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          // todo: reprompt
                          print('reprompt this!');
                        },
                      ),
                      title: Text(widget.prompt.prompt),
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
                  title: Text(myReply.reply),
                  leading: AppFutureBuilder(
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
