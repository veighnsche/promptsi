import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/services/cache/mixins/map_cache.dart';

class ProfilesCache extends MapCache<AppProfile> {
  factory ProfilesCache() => _instance;
  static final ProfilesCache _instance = ProfilesCache._internal();

  ProfilesCache._internal();

  @override
  bool canReplace(AppProfile map, {String? id}) => false;
}
