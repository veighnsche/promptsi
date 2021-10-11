import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/services/cache/profiles_cache.dart';

class ProfileApi {
  static ProfilesCache get _profilesCache => ProfilesCache();

  static final CollectionReference _profilesRef = FirebaseFirestore.instance
      .collection('profiles')
      .withConverter<AppProfile>(
        toFirestore: (AppProfile profile, _) => profile.toJson(),
        fromFirestore: (snapshot, _) {
          return AppProfile.fromJson(snapshot.reference, snapshot.data()!);
        },
      );

  static AppProfile _handleSnapshot(DocumentSnapshot snapshot) {
    AppProfile profile = snapshot.data() as AppProfile;
    _profilesCache.add(profile, id: profile.id);
    return profile;
  }

  static Future<AppProfile?> fetchProfile(String profileId) async {
    if (!_profilesCache.exists(profileId)) {
      print('fetching profile $profileId');
      return _profilesRef.doc(profileId).get().then(
        (DocumentSnapshot snapshot) {
          if (!snapshot.exists) {
            return null;
          }

          return _handleSnapshot(snapshot);
        },
      );
    }

    return _profilesCache.get(profileId);
  }

  static Future<List<AppProfile>?> fetchMatchingProfiles(AppProfile profile) {
    return _profilesRef
        .where('gender', whereIn: profile.listedInterestedIn)
        .get()
        .then(
      (QuerySnapshot snapshot) {
        if (snapshot.docs.isEmpty) {
          /// can be nullable
          return null;
        }

        return snapshot.docs.map(_handleSnapshot).toList();
      },
    );
  }

  static Future<AppProfile> create(
    String userId,
    AppProfile profile,
  ) async {
    final DocumentReference ref = _profilesRef.doc(userId);
    await ref.set(profile);
    return ref.get().then(_handleSnapshot);
  }

  static Future<AppProfile> edit(AppProfile profile) async {
    await profile.reference.update(profile.toJson());
    return fetchProfile(profile.reference.id) as AppProfile;
  }
}
