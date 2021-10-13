import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';

class AppChatMessage extends WithDocumentReference {
  AppChatMessage(
    DocumentReference<Object?>? reference, {
    required this.message,
  }) : super(reference);

  final Map<Iam, String?> message;

  AppChatMessage.create(this.message) : super(null);

  AppChatMessage.fromJson(
    DocumentReference<Object?>? reference,
    Map<String, dynamic> json,
  )   : message = {Iam.user1: json['user1'], Iam.user2: json['user2']},
        super(reference);

  Map<String, dynamic> get json {
    return {'user1': message[Iam.user1], 'user2': message[Iam.user2]};
  }
}
