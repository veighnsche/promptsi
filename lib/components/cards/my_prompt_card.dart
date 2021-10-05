import 'package:flutter/material.dart';
import 'package:prompts_game/models/app_prompt.dart';

class MyPromptCard extends StatefulWidget {
  const MyPromptCard({
    Key? key,
    required this.prompt,
  }) : super(key: key);

  final AppPrompt prompt;

  @override
  State<MyPromptCard> createState() => _MyPromptCardState();
}

class _MyPromptCardState extends State<MyPromptCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              ListTile(
                title: Text(widget.prompt.prompt),
                // subtitle: Text(widget.prompt.madeByString),
              ),
              const Divider(),
              // AppFutureBuilder(
              //   future: widget.prompt.,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
