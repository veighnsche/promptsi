import 'package:flutter/material.dart';
import 'package:prompts_game/components/cards/prompt_card.dart';
import 'package:prompts_game/models/app_prompt.dart';

class MyPromptsColumn extends StatelessWidget {
  const MyPromptsColumn({Key? key, required this.prompts}) : super(key: key);

  final List<AppPrompt> prompts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: prompts.map((AppPrompt prompt) {
        return PromptCard(
          prompt: prompt,
          type: PromptCardType.onProfile,
        );
      }).toList(),
    );
  }
}
