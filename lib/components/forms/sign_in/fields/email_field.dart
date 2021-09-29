import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  const EmailField({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  String? _validator(value) {
    if (value!.isEmpty) {
      return 'Please enter your email';
    }
    if(!value.contains(RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'))) {
      return 'Please enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      controller: controller,
      validator: _validator,
      keyboardType: TextInputType.emailAddress,
    );
  }
}
