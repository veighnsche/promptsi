import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat_message.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/services/apis/chat_messages_api.dart';
import 'package:prompts_game/services/apis/firebase/auth_api.dart';

class AppChat extends WithDocumentReference {
  AppChat(
    DocumentReference reference, {
    required this.user1,
    required this.user2,
  }) : super(reference);

  final String user1;
  final String user2;

  Iam get iam => user1 == AuthApi.uid ? Iam.user1 : Iam.user2;
  Iam get you => iam == Iam.user1 ? Iam.user2 : Iam.user1;

  Stream<List<AppChatMessage>?> get messagesStream {
    return ChatMessagesApi(reference).streamMessages;
  }

  Future<void> sendMessage(String message) {
    String now = DateTime.now().millisecondsSinceEpoch.toString();
    AppChatMessage appMessage = AppChatMessage.create({iam: message});
    return reference.collection('messages').doc(now).set(appMessage.json);
  }

  AppChat.create({required this.user1, required this.user2}) : super(null);

  AppChat.fromJson(DocumentReference reference, Map<String, dynamic> json)
      : user1 = json['user1'],
        user2 = json['user2'],
        super(reference);

  Map<String, dynamic> get json => {'user1': user1, 'user2': user2};
}

enum Iam { user1, user2 }
