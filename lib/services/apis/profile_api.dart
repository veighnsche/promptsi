import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prompts_game/models/profile_model.dart';

class ProfileApi {
  static CollectionReference firestoreRef = FirebaseFirestore.instance
      .collection('profiles')
      .withConverter<ProfileModel>(
        fromFirestore: (snapshot, _) => ProfileModel.fromJson(snapshot.data()!),
        toFirestore: (ProfileModel profile, _) => profile.toJson(),
      );

  static Future<ProfileModel?> has(String userId) {
    return firestoreRef
        .where('userId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return snapshot.docs.elementAt(0).data() as ProfileModel;
    });
  }

  static Future<ProfileModel?> create(
    ProfileModel profile,
    XFile profilePicture,
  ) async {
    final FirebaseStorage _storage = FirebaseStorage.instance;
    return _storage
        .ref()
        .child(profile.imagePath)
        .putFile(File(profilePicture.path))
        .then((_) {
      return firestoreRef
          .add(profile)
          .then((DocumentReference value) => value.get())
          .then((DocumentSnapshot profile) => profile.data() as ProfileModel);
    });
  }
}
