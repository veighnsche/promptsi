import 'package:flutter/material.dart';
import 'package:prompts_game/components/cards/prompt_card.dart';
import 'package:prompts_game/models/app_prompt.dart';

class PromptsColumn extends StatefulWidget {
  const PromptsColumn({
    Key? key,
    required this.prompts,
    this.withPictures = true,
  }) : super(key: key);

  final List<AppPrompt> prompts;
  final bool withPictures;

  @override
  State<PromptsColumn> createState() => _PromptsColumnState();
}

class _PromptsColumnState extends State<PromptsColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.prompts.map((AppPrompt prompt) {
        return PromptCard(
          owner: prompt.owner!,
          prompt: prompt,
          withPictures: widget.withPictures,
        );
      }).toList(),
    );
  }
}
