import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/loading_body.dart';
import 'package:prompts_game/components/columns/my_prompts_column.dart';
import 'package:prompts_game/components/widgets/picture_carousel.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/services/apis/prompts_api.dart';
import 'package:prompts_game/services/apis/storage_api.dart';

class MyProfileBody extends StatefulWidget {
  const MyProfileBody({Key? key, required this.profile}) : super(key: key);

  final AppProfile profile;

  @override
  State<StatefulWidget> createState() => _MyProfileBodyState();
}

class _MyProfileBodyState extends State<MyProfileBody> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        FutureBuilder(
          future: StorageApi.fetchPictureUrls(widget.profile.userId),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasError) {
              throw snapshot.error!;
              // return Text(snapshot.error.toString());
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return PictureCarousel.profile(pictures: snapshot.data!);
            }

            return const AspectRatio(
              aspectRatio: 1,
              child: LoadingBody(),
            );
          },
        ),
        const SizedBox(height: 16),
        FutureBuilder(
          future: PromptsApi.fetchUserPrompts(widget.profile.userId),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<AppPrompt>?> snapshot,
          ) {
            if (snapshot.hasError) {
              throw snapshot.error!;
              // return Text(snapshot.error.toString());
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return MyPromptsColumn(prompts: snapshot.data!);
            }

            return const LoadingBody();
          },
        ),
      ],
    );
  }
}
