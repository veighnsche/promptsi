import 'package:flutter/material.dart';
import 'package:prompts_game/components/cards/prompt_card.dart';
import 'package:prompts_game/models/app_prompt.dart';

class PromptsColumn extends StatelessWidget {
  const PromptsColumn({
    Key? key,
    required this.prompts,
    required this.promptCardType,
  }) : super(key: key);

  final List<AppPrompt> prompts;
  final PromptCardType promptCardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: prompts.map((AppPrompt prompt) {
        return PromptCard(
          prompt: prompt,
          type: promptCardType,
        );
      }).toList(),
    );
  }
}
