import 'package:flutter/material.dart';
import 'package:prompts_game/models/app_profile.dart';

class ProfileInterestedIn extends StatelessWidget {
  const ProfileInterestedIn({
    Key? key,
    required this.interestedIn,
    required this.onInterestedInChange,
  }) : super(key: key);

  final List<AppGenders> interestedIn;
  final Function(AppGenders, bool?) onInterestedInChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('women'),
          leading: Checkbox(
            value: interestedIn.contains(AppGenders.woman),
            onChanged: (bool? hasGender) {
              onInterestedInChange(AppGenders.woman, hasGender);
            },
          ),
        ),
        ListTile(
          title: const Text('men'),
          leading: Checkbox(
            value: interestedIn.contains(AppGenders.man),
            onChanged: (bool? hasGender) {
              onInterestedInChange(AppGenders.man, hasGender);
            },
          ),
        ),
        ListTile(
          title: const Text('gender neutral'),
          leading: Checkbox(
            value: interestedIn.contains(AppGenders.neutral),
            onChanged: (bool? hasGender) {
              onInterestedInChange(AppGenders.neutral, hasGender);
            },
          ),
        ),
      ],
    );
  }
}
