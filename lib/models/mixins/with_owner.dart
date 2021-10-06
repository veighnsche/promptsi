import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/services/apis/profile_api.dart';

mixin WithOwner {
  String get ownerId;
  AppProfile? _owner;

  Future<String> get ownerPicture {
    return owner.then((AppProfile profile) => profile.picture);
  }

  Future<List<String>> get ownerPictures {
    return owner.then((AppProfile profile) => profile.pictures);
  }

  Future<AppProfile> get owner async {
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
