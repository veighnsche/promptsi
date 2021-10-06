import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class BubbleCurrentUser extends StatelessWidget {
  const BubbleCurrentUser({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Bubble(
      alignment: Alignment.centerRight,
      nip: BubbleNip.rightBottom,
      color: Colors.blue,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
