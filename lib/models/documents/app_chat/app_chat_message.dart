import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';

class AppChatMessage extends WithDocumentReference {
  AppChatMessage(
    DocumentReference<Object?>? reference, {
    this.user1Message,
    this.user2Message,
  }) : super(reference);

  final String? user1Message;
  final String? user2Message;

  AppChatMessage.fromJson(
    DocumentReference<Object?>? reference,
    Map<String, dynamic> json,
  )   : user1Message = json['user1'],
        user2Message = json['user2'],
        super(reference);

  Map<String, dynamic> get json {
    return {
      'user1': user1Message,
      'user2': user2Message,
    };
  }
}
