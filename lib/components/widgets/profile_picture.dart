import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:prompts_game/components/builders/app_future_builder.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    Key? key,
    required this.pictureUint8ListAsync,
    required this.pictureUint8List,
  }) : super(key: key);

  final Future<Uint8List> pictureUint8ListAsync;
  final Uint8List? pictureUint8List;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 3 / 4,
      child: AspectRatio(
        aspectRatio: 1,
        child: AppFutureBuilder.skipFuture(
          future: pictureUint8ListAsync,
          initialData: pictureUint8List,
          builder: (context, Uint8List? pictureUint8List) {
            if (pictureUint8List == null) {
              return const SizedBox.shrink();
            }

            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: Image.memory(
                    pictureUint8List,
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
