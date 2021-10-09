import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageUtils {
  static Future<List<String>> listRefsToUrls(List<Reference> references) {
    return Future.wait(
      references.map((Reference ref) => ref.getDownloadURL()).toList(),
    );
  }

  static Future<String> refToBase64(Reference ref) {
    return ref.getData().then((Uint8List? uint8list) {
      if (uint8list == null) {
        throw 'no uint8list';
      }
      return base64Encode(uint8list);
    });
  }
}
