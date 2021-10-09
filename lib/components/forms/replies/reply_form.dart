import 'package:flutter/material.dart';
import 'package:prompts_game/components/utils/decorations/input_decorations.dart';
import 'package:prompts_game/models/app_prompt.dart';

class ReplyForm extends StatefulWidget {
  const ReplyForm({
    Key? key,
    required this.onReplySend,
    required this.selectedPrompt,
  }) : super(key: key);

  final Function(String) onReplySend;
  final AppPrompt selectedPrompt;

  @override
  State<ReplyForm> createState() => _ReplyFormState();
}

class _ReplyFormState extends State<ReplyForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reply = TextEditingController();

  void _onReplySend() {
    widget.onReplySend(_reply.text);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        autofocus: true,
        controller: _reply,
        // validator: _validator,
        decoration: InputDecorations.outline(
          labelText: 'Replying to: ${widget.selectedPrompt.prompt}',
          suffixIcon: IconButton(
            icon: const Icon(Icons.send),
            onPressed: _onReplySend,
          ),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }
}
