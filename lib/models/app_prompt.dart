import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_reply.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/services/apis/profile_api.dart';
import 'package:prompts_game/services/apis/reply_api.dart';

class AppPrompt with WithDocumentReference {
  AppPrompt({
    required this.madeById,
    required this.prompt,
  });

  final String madeById;
  final String prompt;

  AppProfile? _madeBy;
  AppReply? _myReply;
  List<AppReply>? _replies;

  ReplyApi get _replyApi => ReplyApi(reference);

  Future<AppProfile> get madeBy async {
    if (_madeBy != null) {
      return _madeBy!;
    }

    return _madeBy = await ProfileApi.fetchProfile(madeById).then<AppProfile>(
      (AppProfile? profile) {
        if (profile == null) {
          throw 'no made by profile';
        }
        return profile;
      },
    );
  }

  /// can be null if user has never replied to this prompt
  Future<AppReply?> get myReply async {
    if (_myReply != null) {
      return _myReply;
    }
    return _myReply = await _replyApi.myReply;
  }

  Future<AppReply> addReply(String reply) async {
    return _myReply = await _replyApi.create(reply);
  }

  /// can be null, if there are no replies
  Future<List<AppReply>?> get replies async {
    if (_replies != null) {
      return _replies;
    }
    return _replies = await _replyApi.replies;
  }

  Stream<List<AppReply>?> get replyStream {
    return _replyApi.replyStream;
  }

  AppPrompt.fromJson(Map<String, dynamic> json)
      : madeById = json['madeById'],
        prompt = json['prompt'];

  Map<String, dynamic> toJson() => {
        'madeById': madeById,
        'prompt': prompt,
      };
}
