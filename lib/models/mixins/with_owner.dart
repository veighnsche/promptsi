import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/services/apis/profile_api.dart';

mixin WithOwner {
  String get ownerId;

  AppProfile? _owner;

  AppProfile? get owner {
    return _owner;
  }

  String? get profilePictureBase64 {
    return owner?.profilePictureBase64;
  }

  Future<String> get profilePictureBase64Async {
    return ownerAsync.then((AppProfile profile) {
      return profile.profilePictureBase64Async;
    });
  }

  Future<List<String>> get ownerPicturesAsync {
    return ownerAsync.then((AppProfile profile) => profile.pictures);
  }

  Future<AppProfile> get ownerAsync async {
    if (_owner != null) {
      return _owner!;
    }
    return _owner = await ProfileApi.fetchProfile(ownerId).then<AppProfile>(
      (AppProfile? profile) {
        if (profile == null) {
          throw 'no owner profile';
        }
        return profile;
      },
    );
  }
}
