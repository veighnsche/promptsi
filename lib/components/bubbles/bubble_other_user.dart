import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/widgets/app_future_builder.dart';
import 'package:prompts_game/models/app_profile.dart';

class BubbleOtherUser extends StatelessWidget {
  const BubbleOtherUser.onFeed({
    Key? key,
    this.profileAsync,
    required this.text,
    this.type = BubbleOtherUserType.onFeed,
  }) : super(key: key);

  const BubbleOtherUser.onMyProfile({
    Key? key,
    required this.profileAsync,
    required this.text,
    this.type = BubbleOtherUserType.onMyProfile,
  }) : super(key: key);

  const BubbleOtherUser({
    Key? key,
    required this.profileAsync,
    required this.text,
    required this.type,
  }) : super(key: key);

  final Future<AppProfile>? profileAsync;
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
              builder: (context, AppProfile profile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${profile.firstName}, ${profile.age}',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'future location',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                );
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

enum BubbleOtherUserType {
  onMyProfile,
  onFeed,
}
