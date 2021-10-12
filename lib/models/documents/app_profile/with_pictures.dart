import 'package:prompts_game/services/apis/firebase/storage_api.dart';
import 'package:prompts_game/services/cache/pictures_cache.dart';

mixin WithPictures {
  String get id;

  PicturesCache get _picturesCache => PicturesCache();

  List<String>? get pictures {
    if (!_picturesCache.exists(id)) {
      return null;
    }
    return _picturesCache.get(id);
  }

  Future<List<String>> get picturesAsync async {
    return StorageApi.fetchPictureUrls(id);
  }
}
