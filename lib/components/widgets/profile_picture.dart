import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:prompts_game/components/builders/app_future_builder.dart';
import 'package:prompts_game/components/widgets/blur_layer.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';
import 'package:prompts_game/models/store/matches_store.dart';
import 'package:provider/provider.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    Key? key,
    required this.profile,
    this.profileAsync,
  }) : super(key: key);

  final AppProfile? profile;
  final Future<AppProfile?>? profileAsync;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 3 / 4,
      child: AspectRatio(
        aspectRatio: 1,
        child: AppFutureBuilder.skipFuture(
          future: profileAsync,
          initialData: profile,
          builder: (context, AppProfile? profile) {
            if (profile == null) {
              return const SizedBox.shrink();
            }

            return Consumer<MatchesStore>(
              builder: (context, MatchesStore matchesStore, child) {
                return ProfilePictureImage(
                  profile: profile,
                  withBlur: !matchesStore.hasMatch(profile.id),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ProfilePictureImage extends StatelessWidget {
  const ProfilePictureImage(
      {Key? key, required this.profile, this.withBlur = false})
      : super(key: key);

  final AppProfile profile;
  final bool withBlur;

  @override
  Widget build(BuildContext context) {
    return AppFutureBuilder.skipFuture(
      future: profile.profilePictureAsync,
      initialData: profile.profilePicture,
      builder: (context, Uint8List? pictureUint8List) {
        if (pictureUint8List == null) {
          return const SizedBox.shrink();
        }

        return ClipOval(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: Image.memory(
                      pictureUint8List,
                      fit: BoxFit.cover,
                    ).image,
                  ),
                ),
              ),
              if (withBlur) const BlurLayer(sigma: 4)
            ],
          ),
        );
      },
    );
  }
}
