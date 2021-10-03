import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/loading_body.dart';
import 'package:prompts_game/components/scaffolds/profile_scaffold.dart';
import 'package:prompts_game/components/widgets/picture_carousel.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_prompt.dart';

class PromptsColumn extends StatefulWidget {
  const PromptsColumn({
    Key? key,
    required this.prompts,
    this.withPictures = true,
  }) : super(key: key);

  final List<AppPrompt> prompts;
  final bool withPictures;

  @override
  State<PromptsColumn> createState() => _PromptsColumnState();
}

class _PromptsColumnState extends State<PromptsColumn> {
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
    return Column(
      children: widget.prompts.map((AppPrompt prompt) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  if (widget.withPictures)
                    FutureBuilder(
                      future: prompt.owner!.fetchPictures(),
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
                          aspectRatio: 1,
                          child: LoadingBody(),
                        );
                      },
                    ),
                  ListTile(
                    onTap: () => _goToProfile(prompt.owner!),
                    title: Text(
                        '${prompt.owner!.firstName}, ${prompt.owner!.age}'),
                    subtitle: const Text('future location'),
                  ),
                  ListTile(
                    title: Text(prompt.prompt),
                    subtitle: Text(prompt.madeByString),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
