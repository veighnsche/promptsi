import 'package:prompts_game/services/cache/mixins/map_cache.dart';

class PicturesCache extends MapCache<List<String>> {
  factory PicturesCache() => _instance;
  static final PicturesCache _instance = PicturesCache._internal();

  PicturesCache._internal();
}
