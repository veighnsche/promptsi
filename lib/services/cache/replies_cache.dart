import 'package:prompts_game/models/app_reply.dart';
import 'package:prompts_game/services/apis/firebase/auth_api.dart';
import 'package:prompts_game/services/cache/mixins/nested_map_cache.dart';

class RepliesCache extends NestedMapCache<AppReply> {
  factory RepliesCache() => _instance;
  static final RepliesCache _instance = RepliesCache._internal();

  RepliesCache._internal();

  @override
  bool canReplace(
    String parentId,
    AppReply map,
    NestedMap<AppReply> nestedMap, {
    String? id,
  }) {
    final AppReply cached = nestedMap[parentId]![map.id]!;
    return !exists(parentId, map.id) ||
        cached.reply != map.reply ||
        cached.reaction != map.reaction;
  }

  AppReply getMyReply(String promptId) {
    return get(promptId, AuthApi.uid);
  }
}
