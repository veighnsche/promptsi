import 'package:flutter/material.dart';
import 'package:prompts_game/components/cards/prompt_poster_card.dart';
import 'package:prompts_game/models/app_prompt.dart';

class PromptsPosterColumn extends StatelessWidget {
  const PromptsPosterColumn({
    Key? key,
    required this.prompts,
  }) : super(key: key);

  final List<AppPrompt> prompts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: prompts.map((AppPrompt prompt) {
        return PromptPosterCard(prompt: prompt);
      }).toList(),
    );
  }
}
