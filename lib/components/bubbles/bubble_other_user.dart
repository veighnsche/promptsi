import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/widgets/app_future_builder.dart';
import 'package:prompts_game/models/app_profile.dart';

class BubbleOtherUser extends StatelessWidget {
  const BubbleOtherUser({
    Key? key,
    required this.profileAsync,
    required this.text,
  }) : super(key: key);

  final Future<AppProfile> profileAsync;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Bubble(
      nip: BubbleNip.leftTop,
      color: Colors.white38,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppFutureBuilder(
            future: profileAsync,
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
