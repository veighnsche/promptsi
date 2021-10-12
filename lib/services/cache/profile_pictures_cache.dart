import 'dart:typed_data';

import 'package:prompts_game/services/cache/mixins/map_cache.dart';

class ProfilePicturesCache extends MapCache<Uint8List> {
  factory ProfilePicturesCache() => _instance;
  static final ProfilePicturesCache _instance =
      ProfilePicturesCache._internal();

  ProfilePicturesCache._internal();
}
