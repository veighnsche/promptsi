import 'package:prompts_game/models/app_reply.dart';
import 'package:prompts_game/services/apis/firebase/auth_api.dart';

class RepliesCache {
  factory RepliesCache() => _instance;
  static final RepliesCache _instance = RepliesCache._internal();

  RepliesCache._internal();

  final Map<String, Map<String, AppReply>> _replies = {};

  bool has(String promptId) {
    return _replies[promptId] != null;
  }

  bool exists(String promptId, String replyId) {
    return _replies[promptId]?[replyId] != null;
  }

  bool canAddReply(String promptId, AppReply reply) {
    return !exists(promptId, reply.id) ||
        _replies[promptId]![reply.id]!.reply != reply.reply;
  }

  void add(String promptId, AppReply reply) {
    if (!has(promptId)) {
      _replies[promptId] = {reply.id:reply};
    } else if (canAddReply(promptId, reply)) {
      _replies[promptId]![reply.id] = reply;
    }
  }

  List<AppReply> get(String promptId) {
    return _replies[promptId]!.values.toList();
  }

  AppReply getMyReply(String promptId) {
    return _replies[promptId]![AuthApi.uid]!;
  }
}
