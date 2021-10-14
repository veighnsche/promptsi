import 'package:prompts_game/models/documents/app_match/app_match.dart';
import 'package:prompts_game/services/cache/mixins/map_cache.dart';

class MatchesCache extends MapCache<AppMatch> {
  factory MatchesCache() => _instance;
  static final MatchesCache _instance = MatchesCache._internal();

  MatchesCache._internal();
}
