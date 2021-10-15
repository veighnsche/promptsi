import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat.dart';
import 'package:prompts_game/models/documents/app_match/app_match.dart';
import 'package:prompts_game/services/apis/matches_api.dart';
import 'package:prompts_game/services/apis/firebase/auth_api.dart';
import 'package:prompts_game/services/cache/chats_cache.dart';

class ChatsApi {
  static CollectionReference get _chatsRef =>
      FirebaseFirestore.instance.collection('chats').withConverter<AppChat>(
            toFirestore: (chat, options) => chat.json,
            fromFirestore: (snapshot, options) => AppChat.fromJson(
              snapshot.reference,
              snapshot.data()!,
            ),
          );

  static ChatsCache get _chatsCache => ChatsCache();

  static Future<AppChat> fetchChat(String chatId) async {
    if (!_chatsCache.exists(chatId)) {
      return _chatsRef.doc(chatId).get().then(_handleSnapshot);
    }
    return _chatsCache.get(chatId);
  }

  static Future<AppChat?> fetchProfileChat(String profileId) async {
    return MatchesApi.fetchMatch(profileId).then(
      (AppMatch? match) async {
        if (match == null) {
          return null;
        }
        return fetchChat(match.chatId);
      },
    );
  }

  static Future<void> createChatNotExists(String profileId) async {
    await MatchesApi.fetchMatch(profileId).then(
      (AppMatch? match) async {
        if (match == null) {
          await createChat(profileId);
        }
      },
    );
  }

  static Future<AppChat> createChat(String user2Id) {
    AppChat chat = AppChat.create(user1: AuthApi.uid, user2: user2Id);
    return _chatsRef.add(chat).then((DocumentReference ref) async {
      print('chat created');
      return ref.get().then(_handleSnapshot);
    });
  }

  static AppChat _handleSnapshot(DocumentSnapshot snapshot) {
    AppChat chat = snapshot.data() as AppChat;
    _chatsCache.add(chat);
    return chat;
  }
}
