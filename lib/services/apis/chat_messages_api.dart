import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat_message.dart';

class ChatMessagesApi {
  ChatMessagesApi(this.chatRef);

  final DocumentReference chatRef;

  CollectionReference get _chatMessagesRef {
    return chatRef.collection('messages').withConverter<AppChatMessage>(
        fromFirestore: (snapshot, options) => AppChatMessage.fromJson(
              snapshot.reference,
              snapshot.data()!,
            ),
        toFirestore: (AppChatMessage chatMessage, options) => chatMessage.json);
  }

  Stream<List<AppChatMessage>?> get streamMessages {
    return _chatMessagesRef.snapshots().map(_handleQuerySnapshot);
  }

  Future<List<AppChatMessage>?> get fetchMessages {
    return _chatMessagesRef.get().then(_handleQuerySnapshot);
  }

  List<AppChatMessage>? _handleQuerySnapshot(QuerySnapshot snapshot) {
    if (snapshot.docs.isEmpty) {
      /// can be nullable
      return null;
    }

    return snapshot.docs.map(_handleDocumentSnapshot).toList();
  }

  AppChatMessage _handleDocumentSnapshot(DocumentSnapshot doc) {
    return doc.data() as AppChatMessage;
  }
}
