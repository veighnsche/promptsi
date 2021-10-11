import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/models/mixins/with_owner.dart';

class AppChatHeader with WithDocumentReference, WithOwner {
  AppChatHeader({required this.updatedOn});

  final int updatedOn;

  @override
  String get ownerId => id;

  AppChatHeader.fromJson(Map<String, dynamic> json)
      : updatedOn = json['updatedOn'];

  Map<String, dynamic>  get json => {'updatedOn': updatedOn};
}

class AppChat with WithDocumentReference {}
