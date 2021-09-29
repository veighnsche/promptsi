import 'package:flutter/material.dart';

class ProfileNameField extends StatelessWidget {
  const ProfileNameField({Key? key, required this.controller})
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
      decoration: const InputDecoration(
        labelText: 'First Name',
      ),
      keyboardType: TextInputType.text,
    );
  }
}
