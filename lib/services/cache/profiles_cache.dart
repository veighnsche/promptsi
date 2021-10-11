import 'package:prompts_game/models/app_profile.dart';

class ProfilesCache {
  factory ProfilesCache() => _instance;
  static final ProfilesCache _instance = ProfilesCache._internal();

  ProfilesCache._internal();

  final Map<String, AppProfile> _profiles = {};

  bool has(String profileId) {
    return _profiles[profileId] != null;
  }

  void add(AppProfile profile) {
    if (!has(profile.id) || canSet()) {
      print('setting profile ${profile.id}');
      _profiles[profile.id] = profile;
    }
  }

  AppProfile get(String profileId) {
    return _profiles[profileId]!;
  }

  bool canSet() => false;
}
