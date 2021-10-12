import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/models/mixins/with_owner.dart';

class AppChatHeader extends WithDocumentReference with WithOwner {
  AppChatHeader(DocumentReference reference, {required this.updatedOn})
      : super(reference);

  final int updatedOn;

  @override
  String get ownerId => id;

  AppChatHeader.fromJson(DocumentReference reference, Map<String, dynamic> json)
      : updatedOn = json['updatedOn'],
        super(reference);

  Map<String, dynamic> get json => {'updatedOn': updatedOn};
}

class AppChat extends WithDocumentReference {
  AppChat(DocumentReference reference) : super(reference);
}
