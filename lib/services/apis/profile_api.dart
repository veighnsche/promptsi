import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/app_profile.dart';

class ProfileApi {
  static final CollectionReference _profilesRef = FirebaseFirestore.instance
      .collection('profiles')
      .withConverter<AppProfile>(
        fromFirestore: (snapshot, _) {
          return AppProfile.fromJson(snapshot.data()!)
            ..reference = snapshot.reference;
        },
        toFirestore: (AppProfile profile, _) => profile.toJson(),
      );

  static AppProfile _handleSnapshot(DocumentSnapshot snapshot) {
    return snapshot.data() as AppProfile;
  }

  static Future<AppProfile?> fetchProfile(String profileId) {
    return _profilesRef.doc(profileId).get().then((DocumentSnapshot snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return snapshot.data() as AppProfile;
    });
  }

  static Future<List<AppProfile>?> fetchMatchingProfiles(AppProfile profile) {
    return _profilesRef
        .where('gender', whereIn: profile.listedInterestedIn)
        .get()
        .then(
      (QuerySnapshot snapshot) {
        if (snapshot.docs.isEmpty) {
          // throw 'profile snapshot docs is empty userId: $profile';
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
