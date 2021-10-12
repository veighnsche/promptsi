import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/documents/app_reply/app_reply.dart';
import 'package:prompts_game/services/apis/replies_api.dart';
import 'package:prompts_game/services/cache/replies_cache.dart';

mixin WithReplies {
  String get id;

  DocumentReference get reference;

  RepliesCache get _repliesCache => RepliesCache();

  RepliesApi get _repliesApi => RepliesApi(reference);

  List<AppReply>? get replies {
    if (!_repliesCache.parentHas(id)) {
      return null;
    }
    return _repliesCache.toList(id);
  }

  /// can be null, if there are no replies
  Future<List<AppReply>?> get repliesAsync async {
    return _repliesApi.fetchReplies;
  }

  Stream<List<AppReply>?> get replyStream {
    return _repliesApi.streamReplies;
  }
}
