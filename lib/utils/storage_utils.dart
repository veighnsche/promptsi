import 'package:firebase_storage/firebase_storage.dart';

class StorageUtils {
  static Future<List<String>> listRefsToUrls(List<Reference> references) {
    return Future.wait(
      references.map((Reference ref) => ref.getDownloadURL()).toList(),
    );
  }
}
