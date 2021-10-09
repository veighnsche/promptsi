import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/widgets/app_future_builder.dart';
import 'package:prompts_game/models/app_profile.dart';

class BubbleOtherUser extends StatelessWidget {
  const BubbleOtherUser({
    Key? key,
    required this.profileAsync,
    required this.profile,
    required this.text,
    required this.type,
  }) : super(key: key);

  const BubbleOtherUser.onFeed({
    Key? key,
    this.profileAsync,
    this.profile,
    required this.text,
    this.type = BubbleOtherUserType.onFeed,
  }) : super(key: key);

  const BubbleOtherUser.onMyProfile({
    Key? key,
    required this.profileAsync,
    required this.profile,
    required this.text,
    this.type = BubbleOtherUserType.onMyProfile,
  }) : super(key: key);

  final Future<AppProfile>? profileAsync;
  final AppProfile? profile;
  final String text;
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
            AppFutureBuilder(
              future: profileAsync!,
              skipFuture: true,
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
