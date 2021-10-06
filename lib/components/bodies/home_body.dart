import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/loading_body.dart';
import 'package:prompts_game/components/cards/prompt_replier_card.dart';
import 'package:prompts_game/components/columns/prompts_replier_column.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/services/apis/prompts_api.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PromptsApi.fetchPrompts(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<AppPrompt>?> snapshot,
      ) {
        if (snapshot.hasError) {
          throw snapshot.error!;
          // return Text(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            throw 'home feed prompts are empty';
          }

          return SingleChildScrollView(
            child: PromptsReplierColumn(
              prompts: snapshot.data!,
              promptCardType: PromptReplierCardType.onFeed,
            ),
          );
        }

        return const LoadingBody();
      },
    );
  }
}
