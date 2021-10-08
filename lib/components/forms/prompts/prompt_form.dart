import 'package:flutter/material.dart';
import 'package:prompts_game/components/utils/decorations/input_decorations.dart';

class PromptForm extends StatefulWidget {
  const PromptForm({Key? key, required this.onReplySend}) : super(key: key);

  final Future<void> Function(String) onReplySend;

  @override
  State<PromptForm> createState() => _PromptFormState();
}

class _PromptFormState extends State<PromptForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reply = TextEditingController();

  void _onReplySend() {
    widget.onReplySend(_reply.text).whenComplete(() => _reply.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _reply,
        // validator: _validator,
        decoration: InputDecorations.outline(
          labelText: 'Prompt',
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
