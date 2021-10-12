import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/documents/app_reply/app_reply.dart';
import 'package:prompts_game/services/apis/firebase/auth_api.dart';
import 'package:prompts_game/services/apis/replies_api.dart';
import 'package:prompts_game/services/cache/replies_cache.dart';

mixin WithMyReply {
  String get id;

  DocumentReference get reference;

  RepliesCache get _repliesCache => RepliesCache();

  RepliesApi get _repliesApi => RepliesApi(reference);

  bool get hasMyReply {
    return _repliesCache.exists(id, AuthApi.uid);
  }

  AppReply? get myReply {
    if (!_repliesCache.exists(id, AuthApi.uid)) {
      return null;
    }
    return _repliesCache.getMyReply(id);
  }

  /// can be null if user has never replied to this prompt
  Stream<AppReply?> get myReplyStream {
    return _repliesApi.streamMyReply;
  }

  /// can be null if user has never replied to this prompt
  Future<AppReply?> get myReplyAsync async {
    return _repliesApi.fetchMyReply;
  }

  Future<AppReply> addMyReply(String reply) async {
    return _repliesApi.create(reply);
  }
}
