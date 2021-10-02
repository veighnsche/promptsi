import 'package:flutter/material.dart';
import 'package:prompts_game/components/utils/decorations/input_decorations.dart';

class ProfileFirstNameField extends StatelessWidget {
  const ProfileFirstNameField({Key? key, required this.controller})
      : super(key: key);

  final TextEditingController controller;

  String? _validator(String? value) {
    if (value != null && value.split(' ').length > 1) {
      return 'Please enter only one name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: _validator,
      decoration: InputDecorations.outline(
        labelText: 'First name',
      ),
      keyboardType: TextInputType.text,
    );
  }
}
