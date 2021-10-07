import 'package:flutter/material.dart';
import 'package:prompts_game/components/cards/prompt_poster_card.dart';
import 'package:prompts_game/components/forms/prompts/prompt_form.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/services/apis/prompts_api.dart';

class PromptsPosterColumn extends StatelessWidget {
  const PromptsPosterColumn({
    Key? key,
    required this.profile,
    required this.prompts,
  }) : super(key: key);

  final AppProfile profile;
  final List<AppPrompt> prompts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...prompts.map((AppPrompt prompt) {
          return PromptPosterCard(prompt: prompt);
        }).toList(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: PromptForm(
            onReplySend: PromptsApi.createPromptC(profile),
          ),
        ),
      ],
    );
  }
}
