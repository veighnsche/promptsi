import 'package:prompts_game/models/documents/app_reply/app_reply.dart';
import 'package:prompts_game/services/apis/firebase/auth_api.dart';
import 'package:prompts_game/services/cache/mixins/nested_map_cache.dart';

class RepliesCache extends NestedMapCache<AppReply> {
  factory RepliesCache() => _instance;
  static final RepliesCache _instance = RepliesCache._internal();

  RepliesCache._internal();

  @override
  bool canReplace(String parentId, String id, AppReply value, AppReply cache) {
    return cache.reply != value.reply || cache.reaction != value.reaction;
  }

  AppReply getMyReply(String promptId) {
    return get(promptId, AuthApi.uid);
  }
}
