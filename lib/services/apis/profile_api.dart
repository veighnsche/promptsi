import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prompts_game/models/profile_model.dart';
import 'package:prompts_game/services/apis/storage_api.dart';

class ProfileApi {
  static CollectionReference firestoreRef = FirebaseFirestore.instance
      .collection('profiles')
      .withConverter<AppProfile>(
        fromFirestore: (snapshot, _) => AppProfile.fromJson(snapshot.data()!),
        toFirestore: (AppProfile profile, _) => profile.toJson(),
      );

  static Future<AppProfile?> fetchProfile(String userId) {
    return firestoreRef.where('userId', isEqualTo: userId).get().then(
      (QuerySnapshot snapshot) {
        if (snapshot.docs.isEmpty) {
          return null;
        }
        return snapshot.docs.elementAt(0).data() as AppProfile;
      },
    );
  }

  static Future<AppProfile?> create(
    AppProfile profile,
    XFile pictureFile,
  ) async {
    AppProfile profileRes = await firestoreRef
        .add(profile)
        .then((DocumentReference ref) => ref.get())
        .then((DocumentSnapshot snapshot) => snapshot.data() as AppProfile)
        .catchError((e) => throw e);

    String imagePath = '${profileRes.uid}/${DateTime.now()}.jpg';

    await StorageApi.uploadImage(imagePath, pictureFile);
    return profileRes;
  }
}
