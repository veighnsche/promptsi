import 'package:flutter/material.dart';
import 'package:prompts_game/components/utils/decorations/input_decorations.dart';

class ProfileAgeField extends StatelessWidget {
  const ProfileAgeField({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  String? _validatorOlderThan18(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your age';
    } else if (int.tryParse(value) == null) {
      return 'Please enter a valid age';
    } else if (int.parse(value) < 18) {
      return 'You must be older than 18';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: _validatorOlderThan18,
      decoration: InputDecorations.outline(
        labelText: 'Age',
      ),
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.words,
    );
  }
}
