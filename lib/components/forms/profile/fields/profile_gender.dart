import 'package:flutter/material.dart';
import 'package:prompts_game/models/app_profile.dart';

class ProfileGender extends StatelessWidget {
  const ProfileGender({
    Key? key,
    required this.gender,
    required this.onGenderChange,
  }) : super(key: key);

  final AppGenders gender;
  final Function(AppGenders?) onGenderChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('a woman'),
          leading: Radio<AppGenders>(
            value: AppGenders.woman,
            groupValue: gender,
            onChanged: onGenderChange,
          ),
        ),
        ListTile(
          title: const Text('a man'),
          leading: Radio<AppGenders>(
            value: AppGenders.man,
            groupValue: gender,
            onChanged: onGenderChange,
          ),
        ),
        ListTile(
          title: const Text('gender neutral'),
          leading: Radio<AppGenders>(
            value: AppGenders.neutral,
            groupValue: gender,
            onChanged: onGenderChange,
          ),
        ),
      ],
    );
  }
}
