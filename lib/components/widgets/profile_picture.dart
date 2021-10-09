import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prompts_game/components/widgets/app_future_builder.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    Key? key,
    required this.pictureBase64Async,
    required this.pictureBase64,
  }) : super(key: key);

  final Future<String> pictureBase64Async;
  final String? pictureBase64;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 3 / 4,
      child: AspectRatio(
        aspectRatio: 1,
        child: AppFutureBuilder.skipFuture(
          future: pictureBase64Async,
          initialData: pictureBase64,
          builder: (context, String? pictureBase64) {
            if (pictureBase64 == null) {
              return const SizedBox.shrink();
            }

            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: Image.memory(
                    base64Decode(pictureBase64),
                    fit: BoxFit.cover,
                  ).image,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
