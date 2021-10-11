import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prompts_game/services/cache/pictures_cache.dart';
import 'package:prompts_game/services/cache/profile_pictures_cache.dart';
import 'package:prompts_game/utils/storage_utils.dart';

class StorageApi {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static ProfilePicturesCache get _profilePicturesCache =>
      ProfilePicturesCache();
  static PicturesCache get _picturesCache => PicturesCache();

  static Future<Reference> uploadPicture(String userId, XFile pictureFile) {
    final String refPath = 'profiles/$userId/${DateTime.now()}.jpg';
    return _storage.ref().child(refPath).putFile(File(pictureFile.path)).then(
          (TaskSnapshot snapshot) => snapshot.ref,
    );
  }

  static Future<void> deletePicture(Reference ref) {
    return ref.delete();
  }

  static Future<Reference> _fetchProfilePictureRef(String userId) {
    return _storage
        .ref()
        .child('profiles')
        .child(userId)
        .list(const ListOptions(maxResults: 1))
        .then((ListResult list) => list.items.elementAt(0));
  }

  static Future<List<Reference>> fetchPicturesRefs(String userId) {
    return _storage.ref().child('profiles').child(userId).listAll().then(
          (ListResult list) {
        return list.items;
      },
    );
  }

  static Future<Uint8List> fetchProfilePicture(String userId) async {
    if (!_profilePicturesCache.exists(userId)) {
      return _fetchProfilePictureRef(userId).then((Reference list) async {
        Uint8List profilePicture = await StorageUtils.refToUint8list(list);
        _profilePicturesCache.add(profilePicture, id: userId);
        return profilePicture;
      });
    }
    return _profilePicturesCache.get(userId);
  }

  static Future<List<String>> fetchPictureUrls(String userId) async {
    if (!_picturesCache.exists(userId)) {
      return fetchPicturesRefs(userId).then((List<Reference> list) async {
        List<String> pictures = await StorageUtils.listRefsToUrls(list);
        _picturesCache.add(pictures, id: userId);
        return pictures;
      });
    }
    return _picturesCache.get(userId);
  }
}
