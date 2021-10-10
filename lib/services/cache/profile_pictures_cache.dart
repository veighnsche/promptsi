import 'dart:typed_data';

class ProfilePicturesCache {
  factory ProfilePicturesCache() => _instance;
  static final ProfilePicturesCache _instance = ProfilePicturesCache._internal();

  ProfilePicturesCache._internal();

  final Map<String, Uint8List> _profilePicture = {};

  bool has(String profileId) {
    return _profilePicture[profileId] != null;
  }

  void set(String profileId, Uint8List profilePicture) {
    if (!has(profileId)) {
      print('setting profile picture $profileId');
      _profilePicture[profileId] = profilePicture;
    }
  }

  Uint8List get(String profileId) {
    return _profilePicture[profileId]!;
  }
}
