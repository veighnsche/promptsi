import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/loading_body.dart';
import 'package:prompts_game/components/widgets/picture_carousel.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/services/apis/storage_api.dart';

class PromptsColumn extends StatelessWidget {
  const PromptsColumn({Key? key, required this.prompts}) : super(key: key);

  final List<AppPrompt> prompts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: prompts.map((AppPrompt prompt) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  FutureBuilder(
                    future: StorageApi.fetchPictureUrls(prompt.owner!.userId),
                    builder:
                        (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
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
                    title: Text('${prompt.owner!.firstName}, ${prompt.owner!.age}'),
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
