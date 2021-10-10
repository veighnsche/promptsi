import 'package:flutter/material.dart';
import 'package:prompts_game/components/prompts/prompt_poster.dart';
import 'package:prompts_game/models/app_prompt.dart';

class PromptsPosterColumn extends StatelessWidget {
  const PromptsPosterColumn({Key? key, required this.prompts})
      : super(key: key);

  final List<AppPrompt> prompts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: prompts.map((AppPrompt prompt) {
        return PromptPoster(prompt: prompt);
      }).toList(),
    );
  }
}
