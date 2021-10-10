import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageUtils {
  static Future<List<String>> listRefsToUrls(List<Reference> references) {
    return Future.wait(
      references.map((Reference ref) => ref.getDownloadURL()).toList(),
    );
  }

  static Future<Uint8List> refToUint8list(Reference ref) {
    return ref.getData().then((Uint8List? uint8list) {
      if (uint8list == null) {
        throw 'no uint8list';
      }
      return uint8list;
    });
  }
}
