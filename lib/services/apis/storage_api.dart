import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageApi {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<TaskSnapshot> uploadImage(String imagePath, XFile image) {
    return _storage.ref().child(imagePath).putFile(File(image.path));
  }
}
