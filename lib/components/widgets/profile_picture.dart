import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/widgets/app_future_builder.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    Key? key,
    required this.asyncPicture,
  }) : super(key: key);

  final Future<String> asyncPicture;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 3 / 4,
      child: AspectRatio(
        aspectRatio: 1,
        child: AppFutureBuilder(
          future: asyncPicture,
          builder: (context, String picture) {
            return CachedNetworkImage(
              imageUrl: picture,
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
