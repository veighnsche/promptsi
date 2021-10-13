import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat_message.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/services/apis/chat_messages_api.dart';

class AppChat extends WithDocumentReference {
  AppChat(
    DocumentReference reference, {
    required this.user1,
    required this.user2,
  }) : super(reference);

  final String user1;
  final String user2;

  Stream<List<AppChatMessage>?> get messagesStream {
    return ChatMessagesApi(reference).streamMessages;
  }

  AppChat.create({required this.user1, required this.user2}) : super(null);

  AppChat.fromJson(DocumentReference reference, Map<String, dynamic> json)
      : user1 = json['user1'],
        user2 = json['user2'],
        super(reference);

  Map<String, dynamic> get json => {'user1': user1, 'user2': user2};
}
