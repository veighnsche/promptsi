import 'package:flutter/material.dart';
import 'package:prompts_game/components/cards/prompt_replier_card.dart';
import 'package:prompts_game/models/app_prompt.dart';

class PromptsReplierColumn extends StatelessWidget {
  const PromptsReplierColumn({
    Key? key,
    required this.prompts,
    required this.promptCardType,
  }) : super(key: key);

  final List<AppPrompt> prompts;
  final PromptReplierCardType promptCardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: prompts.map((AppPrompt prompt) {
        return PromptReplyCard(
          prompt: prompt,
          type: promptCardType,
        );
      }).toList(),
    );
  }
}
