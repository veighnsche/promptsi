import 'package:flutter/material.dart';
import 'package:prompts_game/models/app_prompt.dart';

class MyPromptsColumn extends StatelessWidget {
  const MyPromptsColumn({Key? key, required this.prompts}) : super(key: key);

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
