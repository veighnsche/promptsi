import 'package:prompts_game/models/app_chat.dart';
import 'package:prompts_game/services/cache/mixins/map_cache.dart';

class ChatHeaderCache extends MapCache<AppChatHeader> {
  factory ChatHeaderCache() => _instance;
  static final ChatHeaderCache _instance = ChatHeaderCache._internal();

  ChatHeaderCache._internal();

  @override
  bool canReplace(AppChatHeader value, {String? id}) => false;
}
