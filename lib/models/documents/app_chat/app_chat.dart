import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';

class AppChat extends WithDocumentReference {
  AppChat(
    DocumentReference reference, {
    required this.user1,
    required this.user2,
  }) : super(reference);

  final String user1;
  final String user2;

  AppChat.create({required this.user1, required this.user2}) : super(null);

  AppChat.fromJson(DocumentReference reference, Map<String, dynamic> json)
      : user1 = json['user1'],
        user2 = json['user2'],
        super(reference);

  Map<String, dynamic> get json => {'user1': user1, 'user2': user2};
}
