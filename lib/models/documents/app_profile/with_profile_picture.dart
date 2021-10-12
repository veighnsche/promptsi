import 'dart:typed_data';

import 'package:prompts_game/services/apis/firebase/storage_api.dart';
import 'package:prompts_game/services/cache/profile_pictures_cache.dart';

mixin WithProfilePicture {
  String get id;

  ProfilePicturesCache get _profilePicturesCache => ProfilePicturesCache();

  Uint8List? get profilePicture {
    if (!_profilePicturesCache.exists(id)) {
      return null;
    }
    return _profilePicturesCache.get(id);
  }

  Future<Uint8List> get profilePictureAsync async {
    return StorageApi.fetchProfilePicture(id);
  }
}
