import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/loading_body.dart';
import 'package:prompts_game/components/scaffolds/profile_scaffold.dart';
import 'package:prompts_game/components/utils/decorations/input_decorations.dart';
import 'package:prompts_game/components/widgets/picture_carousel.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_prompt.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reply = TextEditingController();

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
                FutureBuilder(
                  future: widget.owner.fetchPictures(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.hasError) {
                      throw snapshot.error!;
                      // return Text(snapshot.error.toString());
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      return PictureCarousel.home(pictures: snapshot.data!);
                    }

                    return const AspectRatio(
                      aspectRatio: (3 / 2),
                      child: LoadingBody(),
                    );
                  },
                ),
              ListTile(
                onTap: () => _goToProfile(widget.owner),
                title: Text('${widget.owner.firstName}, ${widget.owner.age}'),
                subtitle: const Text('future location'),
              ),
              ListTile(
                title: Text(widget.prompt.prompt),
                subtitle: Text(widget.prompt.madeByString),
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _reply,
                  // validator: _validator,
                  decoration: InputDecorations.outline(
                    labelText: 'Reply',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        print('send pressed');
                      },
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
