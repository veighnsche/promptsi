import 'dart:typed_data';

import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/services/apis/profile_api.dart';
import 'package:prompts_game/services/cache/profiles_cache.dart';

mixin WithOwner {
  String get ownerId;

  final ProfilesCache cache = ProfilesCache();

  AppProfile? get owner {
    if (!cache.has(ownerId)) {
      return null;
    }
    return cache.get(ownerId);
  }

  set owner(AppProfile? profile) {
    if (profile == null) {
      throw 'no owner profile in profiles instance';
    }
    cache.add(profile);
  }

  Future<AppProfile> get ownerAsync async {
    if (owner != null) {
      return owner!;
    }

    return owner = await ProfileApi.fetchProfile(ownerId).then<AppProfile>(
      (AppProfile? profile) {
        if (profile == null) {
          throw 'no owner profile from firestore';
        }
        return profile;
      },
    );
  }

  Uint8List? get profilePicture {
    return owner?.profilePicture;
  }

  Future<Uint8List> get profilePictureAsync {
    return ownerAsync.then((AppProfile profile) {
      return profile.profilePictureAsync;
    });
  }
}
