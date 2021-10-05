import 'package:cloud_firestore/cloud_firestore.dart';

mixin WithDocumentReference {
  DocumentReference? _reference;

  set reference(DocumentReference reference) {
    _reference = reference;
  }

  DocumentReference get reference {
    if (_reference == null) {
      throw 'no reference, did you forget to set it in the api?';
    }
    return _reference!;
  }
}
