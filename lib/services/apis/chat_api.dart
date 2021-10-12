import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat.dart';
import 'package:prompts_game/services/cache/chat_header_cache.dart';

class ChatApi {
  ChatApi(this.profileRef);

  final DocumentReference profileRef;
  final ChatHeaderCache _chatHeaderCache = ChatHeaderCache();

  CollectionReference get _chatHeaderRef {
    return profileRef.collection('chatHeaders').withConverter<AppChatHeader>(
          toFirestore: (AppChatHeader chatHeader, _) => chatHeader.json,
          fromFirestore: (snapshot, options) {
            return AppChatHeader.fromJson(snapshot.reference, snapshot.data()!);
          },
        );
  }

  Stream<List<AppChatHeader>?> get streamChatList {
    return _chatHeaderRef
        .orderBy('updatedOn', descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }

      return snapshot.docs.map((DocumentSnapshot doc) {
        AppChatHeader chatHeader = doc.data() as AppChatHeader;
        _chatHeaderCache.add(chatHeader);
        return chatHeader;
      }).toList();
    });
  }
}
