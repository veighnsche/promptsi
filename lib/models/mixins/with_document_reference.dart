import 'package:cloud_firestore/cloud_firestore.dart';

class WithDocumentReference {
  WithDocumentReference(DocumentReference? reference) : _reference = reference;

  final DocumentReference? _reference;

  String get id {
    return _reference!.id;
  }

  DocumentReference get reference {
    if (_reference == null) {
      throw 'no reference, did you forget to set it in the api?';
    }
    return _reference!;
  }
}
