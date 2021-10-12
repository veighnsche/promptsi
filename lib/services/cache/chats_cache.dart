import 'package:prompts_game/models/documents/app_chat/app_chat.dart';
import 'package:prompts_game/services/cache/mixins/map_cache.dart';

class ChatsCache extends MapCache<AppChat> {
  factory ChatsCache() => _instance;
  static final ChatsCache _instance = ChatsCache._internal();

  ChatsCache._internal();
}
