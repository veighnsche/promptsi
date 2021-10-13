import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat_tile.dart';
import 'package:prompts_game/services/apis/profile_api.dart';
import 'package:prompts_game/services/cache/chat_tiles_cache.dart';

class ChatTilesApi {
  static ChatTilesCache get _chatTilesCache => ChatTilesCache();

  static CollectionReference get _chatTilesRef {
    return ProfileApi.myProfile.reference
        .collection('chat tiles')
        .withConverter<AppChatTile>(
          toFirestore: (AppChatTile chatTile, _) => chatTile.json,
          fromFirestore: (snapshot, options) {
            return AppChatTile.fromJson(snapshot.reference, snapshot.data()!);
          },
        );
  }

  static Stream<List<AppChatTile>?> get streamChatTiles {
    return _chatTilesRef
        .orderBy('updatedOn', descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }

      return snapshot.docs.map((DocumentSnapshot doc) {
        AppChatTile chatHeader = doc.data() as AppChatTile;
        _chatTilesCache.add(chatHeader);
        return chatHeader;
      }).toList();
    });
  }

  static Future<AppChatTile?> fetchChatTile(String user2Id) async {
    if (!_chatTilesCache.exists(user2Id)) {
      return _chatTilesRef.doc(user2Id).get().then((DocumentSnapshot snapshot) {
        if (!snapshot.exists) {
          return null;
        }
        return _handleSnapshot(snapshot);
      });
    }
    return _chatTilesCache.get(user2Id);
  }

  static AppChatTile _handleSnapshot(DocumentSnapshot snapshot) {
    AppChatTile chatTile = snapshot.data() as AppChatTile;
    _chatTilesCache.add(chatTile);
    return chatTile;
  }
}
