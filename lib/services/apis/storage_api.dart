import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prompts_game/utils/storage_utils.dart';

class StorageApi {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<Reference> uploadPicture(String userId, XFile pictureFile) {
    final String refPath = 'profiles/$userId/${DateTime.now()}.jpg';
    return _storage.ref().child(refPath).putFile(File(pictureFile.path)).then(
          (TaskSnapshot snapshot) => snapshot.ref,
        );
  }

  static Future<void> deletePicture(Reference ref) {
    return ref.delete();
  }

  static Future<Reference> fetchPictureRef(String userId) {
    return _storage
        .ref()
        .child('profiles')
        .child(userId)
        .list(const ListOptions(maxResults: 1))
        .then((ListResult list) => list.items.elementAt(0));
  }

  static Future<List<Reference>> fetchPictureRefs(String userId) {
    return _storage.ref().child('profiles').child(userId).listAll().then(
      (ListResult list) {
        return list.items;
      },
    );
  }

  static Future<String> fetchProfilePictureBase64(String userId) {
    return fetchPictureRef(userId).then((Reference list) {
      return StorageUtils.listRefToBase64(list);
    });
  }

  static Future<List<String>> fetchPictureUrls(String userId) {
    return fetchPictureRefs(userId).then((List<Reference> list) {
      return StorageUtils.listRefsToUrls(list);
    });
  }
}
