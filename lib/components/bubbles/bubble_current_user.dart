import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class BubbleCurrentUser extends StatelessWidget {
  const BubbleCurrentUser({
    Key? key,
    required this.text,
    this.isRePrompt = false,
  }) : super(key: key);

  const BubbleCurrentUser.onMyProfile({
    Key? key,
    required this.text,
    required this.isRePrompt,
  }) : super(key: key);

  final String text;
  final bool isRePrompt;

  @override
  Widget build(BuildContext context) {
    return Bubble(
      alignment: Alignment.centerRight,
      nip: BubbleNip.rightBottom,
      color: Colors.blueGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isRePrompt)
            Text(
              'reprompt',
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontStyle: FontStyle.italic,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
