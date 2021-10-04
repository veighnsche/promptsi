import 'package:flutter/material.dart';
import 'package:prompts_game/components/forms/prompts/reply_form.dart';
import 'package:prompts_game/components/scaffolds/profile_scaffold.dart';
import 'package:prompts_game/components/widgets/picture_carousel.dart';
import 'package:prompts_game/components/widgets/profile_picture.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/models/app_reply.dart';

class PromptCard extends StatefulWidget {
  const PromptCard({
    Key? key,
    required this.prompt,
    required this.owner,
    required this.withPictures,
  }) : super(key: key);

  final AppPrompt prompt;
  final AppProfile owner;
  final bool withPictures;

  @override
  State<PromptCard> createState() => _PromptCardState();
}

class _PromptCardState extends State<PromptCard> {
  late AppReply? myReply;

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
    AppReply response = await widget.prompt.addReply(reply);
    setState(() {
      myReply = response;
    });
  }

  @override
  void initState() {
    super.initState();
    myReply = widget.prompt.myReply;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              if (widget.withPictures)
                PictureCarousel.home(pictures: widget.owner.pictures!),
              ListTile(
                onTap: () => _goToProfile(widget.owner),
                title: Text('${widget.owner.firstName}, ${widget.owner.age}'),
                subtitle: const Text('future location'),
              ),
              ListTile(
                leading: ProfilePicture(
                  imageUrl: widget.owner.profilePicture!,
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
              myReply == null
                  ? ReplyForm(onReplySend: _addReply)
                  : ListTile(
                leading: ProfilePicture(
                  imageUrl: myReply!.owner!.profilePicture!,
                ),
                title: Text(myReply!.reply),
                subtitle: const Text('future relative date'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
