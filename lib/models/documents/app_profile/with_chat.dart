import 'package:prompts_game/models/documents/app_chat/app_chat.dart';
import 'package:prompts_game/services/apis/chats_api.dart';

mixin WithChat {
  String get id;

  Future<void> get startChatNotExists {
    return ChatsApi.createChatNotExists(id);
  }

  Future<AppChat> get startChat {
    return ChatsApi.createChat(id);
  }

  Future<AppChat?> get chatAsync {
    return ChatsApi.fetchProfileChat(id);
  }
}
