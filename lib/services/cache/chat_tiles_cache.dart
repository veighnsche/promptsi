import 'package:prompts_game/models/documents/app_chat/app_chat_tile.dart';
import 'package:prompts_game/services/cache/mixins/map_cache.dart';

class ChatTilesCache extends MapCache<AppChatTile> {
  factory ChatTilesCache() => _instance;
  static final ChatTilesCache _instance = ChatTilesCache._internal();

  ChatTilesCache._internal();
}
