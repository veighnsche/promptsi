import 'package:flutter/material.dart';
import 'package:prompts_game/components/utils/decorations/input_decorations.dart';

class ReplyForm extends StatefulWidget {
  const ReplyForm({Key? key, required this.onReplySend}) : super(key: key);

  final Function(String) onReplySend;

  @override
  State<ReplyForm> createState() => _ReplyFormState();
}

class _ReplyFormState extends State<ReplyForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reply = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        autofocus: true,
        controller: _reply,
        // validator: _validator,
        decoration: InputDecorations.outline(
          labelText: 'Reply',
          suffixIcon: IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => widget.onReplySend(_reply.text),
          ),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }
}
