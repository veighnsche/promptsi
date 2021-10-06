import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/app_profile.dart';

class ProfileApi {
  static final CollectionReference _profilesRef = FirebaseFirestore.instance
      .collection('profiles')
      .withConverter<AppProfile>(
        fromFirestore: (snapshot, _) => AppProfile.fromJson(snapshot.data()!),
        toFirestore: (AppProfile profile, _) => profile.toJson(),
      );

  static Future<DocumentSnapshot> fetchProfileSnapshot(String userId) {
    return _profilesRef.where('userId', isEqualTo: userId).get().then(
      (QuerySnapshot snapshot) {
        if (snapshot.docs.isEmpty) {
          throw 'profile snapshot docs is empty userId: $userId';
        }
        return snapshot.docs.elementAt(0);
      },
    );
  }

  static Future<AppProfile> fetchProfile(String userId) {
    return fetchProfileSnapshot(userId).then(
      (DocumentSnapshot snapshot) async {
        return snapshot.data() as AppProfile..reference = snapshot.reference;
      },
    );
  }

  static Future<AppProfile?> create(AppProfile profileBody) async {
    DocumentReference ref = await _profilesRef.add(profileBody);
    AppProfile profile = await ref.get().then(
          (DocumentSnapshot snapshot) => snapshot.data() as AppProfile,
        );
    return profile..reference = ref;
  }

  static Future<void> edit(AppProfile profile) {
    return profile.reference.update(profile.toJson());
  }
}
