import 'package:flutter/material.dart';
import 'package:prompts_game/components/utils/decorations/input_decorations.dart';

class ChatForm extends StatefulWidget {
  const ChatForm({Key? key, required this.onMessageSend}) : super(key: key);

  final Future<void> Function(String message) onMessageSend;

  @override
  State<ChatForm> createState() => _ChatFormState();
}

class _ChatFormState extends State<ChatForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _message = TextEditingController();

  void _onMessageSend() {
    widget.onMessageSend(_message.text).whenComplete(() => _message.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _message,
        // validator: _validator,
        decoration: InputDecorations.outline(
          labelText: '',
          suffixIcon: IconButton(
            icon: const Icon(Icons.send),
            onPressed: _onMessageSend,
          ),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }
}
