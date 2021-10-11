import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/app_reply.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/services/apis/firebase/auth_api.dart';
import 'package:prompts_game/services/apis/prompts_api.dart';
import 'package:prompts_game/services/apis/replies_api.dart';
import 'package:prompts_game/services/cache/replies_cache.dart';

class AppPrompt extends WithDocumentReference {
  AppPrompt(DocumentReference reference, {
    required this.madeById,
    required this.prompt,
  }): super(reference);

  AppPrompt.create({
    required this.madeById,
    required this.prompt,
  }) : super(null);

  final String madeById;
  final String prompt;

  RepliesCache get _repliesCache => RepliesCache();

  RepliesApi get _repliesApi => RepliesApi(reference);

  bool get hasMyReply {
    return _repliesCache.exists(reference.id, AuthApi.uid);
  }

  AppReply? get myReply {
    if (!_repliesCache.exists(reference.id, AuthApi.uid)) {
      return null;
    }
    return _repliesCache.getMyReply(reference.id);
  }

  /// can be null if user has never replied to this prompt
  Stream<AppReply?> get myReplyStream {
    return _repliesApi.streamMyReply;
  }

  /// can be null if user has never replied to this prompt
  Future<AppReply?> get myReplyAsync async {
    return _repliesApi.fetchMyReply;
  }

  Future<AppReply> addReply(String reply) async {
    return _repliesApi.create(reply);
  }

  List<AppReply>? get replies {
    if (!_repliesCache.parentHas(reference.id)) {
      return null;
    }
    return _repliesCache.toList(reference.id);
  }

  /// can be null, if there are no replies
  Future<List<AppReply>?> get repliesAsync async {
    return _repliesApi.fetchReplies;
  }

  Stream<List<AppReply>?> get replyStream {
    return _repliesApi.streamReplies;
  }

  Future<AppPrompt> rePrompt() async {
    return PromptsApi.createRePrompt(prompt, madeById);
  }

  AppPrompt.fromJson(DocumentReference reference, Map<String, dynamic> json)
      : madeById = json['madeById'],
        prompt = json['prompt'], super(reference);

  Map<String, dynamic> toJson() => {
        'madeById': madeById,
        'prompt': prompt,
        'createdOn': DateTime.now().millisecondsSinceEpoch,
      };
}
