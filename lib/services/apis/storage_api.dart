import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prompts_game/utils/string_utils.dart';

class StorageApi {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> uploadPicture(String userId, XFile pictureFile) {
    final String refPath = 'profiles/$userId/${DateTime.now()}.jpg';
    return _storage.ref().child(refPath).putFile(File(pictureFile.path))
        .then((TaskSnapshot snapshot) => snapshot.ref.getDownloadURL());
  }

  static Future<void> deletePicture(String userId, String picture) {
    final String fileName = StringUtils.getPictureFileNameFromUrl(picture);
    final String refPath = 'profiles/$userId/$fileName';
    return _storage.ref(refPath).delete();
  }

  static Future<List<Reference>> fetchPictureRefs(String userId) {
    return _storage.ref().child('profiles').child(userId).listAll().then(
          (ListResult list) => list.items,
    );
  }

  static Future<List<String>> fetchPictureUrls(String userId) {
    return fetchPictureRefs(userId).then((List<Reference> list) {
      return Future.wait(
        list.map((Reference ref) => ref.getDownloadURL()).toList(),
      );
    });
  }
}
