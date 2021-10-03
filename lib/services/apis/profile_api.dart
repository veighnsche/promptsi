import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/profile_model.dart';

class ProfileApi {
  static final CollectionReference _profileRef = FirebaseFirestore.instance
      .collection('profiles')
      .withConverter<AppProfile>(
        fromFirestore: (snapshot, _) => AppProfile.fromJson(snapshot.data()!),
        toFirestore: (AppProfile profile, _) => profile.toJson(),
      );

  static Future<DocumentSnapshot?> fetchProfileSnapshot(String userId) {
    return _profileRef
        .where('userId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return snapshot.docs.elementAt(0);
    });
  }

  static Future<DocumentReference?> fetchProfileRef(String userId) {
    return fetchProfileSnapshot(userId).then((DocumentSnapshot? snapshot) {
      if (snapshot == null) {
        return null;
      }
      return snapshot.reference;
    });
  }

  static Future<AppProfile?> fetchProfile(String userId) {
    return fetchProfileSnapshot(userId).then((DocumentSnapshot? snapshot) {
      if (snapshot == null) {
        return null;
      }
      return snapshot.data() as AppProfile;
    });
  }

  static Future<AppProfile?> create(AppProfile profile) {
    return _profileRef
        .add(profile)
        .then((DocumentReference ref) => ref.get())
        .then((DocumentSnapshot snapshot) => snapshot.data() as AppProfile);
  }

  static Future<void> edit(AppProfile profile) {
    return fetchProfileRef(profile.userId).then((DocumentReference? profileRef) {
      if (profileRef == null) {
        return null;
      }
      return profileRef.update(profile.toJson());
    });
  }
}
