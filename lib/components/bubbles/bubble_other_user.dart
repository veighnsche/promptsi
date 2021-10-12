import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/builders/app_future_builder.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';

class BubbleOtherUser extends StatelessWidget {
  const BubbleOtherUser({
    Key? key,
    required this.text,
    required this.profileAsync,
    required this.profile,
    required this.type,
  }) : super(key: key);

  const BubbleOtherUser.onFeed({
    Key? key,
    required this.text,
    this.profileAsync,
    this.profile,
    this.type = BubbleOtherUserType.onFeed,
  }) : super(key: key);

  const BubbleOtherUser.onMyProfile({
    Key? key,
    required this.text,
    required this.profileAsync,
    required this.profile,
    this.type = BubbleOtherUserType.onMyProfile,
  }) : super(key: key);

  final String text;
  final Future<AppProfile>? profileAsync;
  final AppProfile? profile;
  final BubbleOtherUserType type;

  @override
  Widget build(BuildContext context) {
    return Bubble(
      nip: BubbleNip.leftTop,
      color: Colors.white38,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (type == BubbleOtherUserType.onMyProfile)
            AppFutureBuilder.skipFuture(
              future: profileAsync!,
              initialData: profile,
              loader: ProfileAsl(profile: profile),
              builder: (context, AppProfile profile) {
                return ProfileAsl(profile: profile);
              },
            ),
          const SizedBox(height: 4),
          Text(
            text,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileAsl extends StatelessWidget {
  const ProfileAsl({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final AppProfile? profile;

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            ',',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '-- Km away',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${profile!.firstName}, ${profile!.age}',
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          '10 Km away',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

enum BubbleOtherUserType {
  onMyProfile,
  onFeed,
}
