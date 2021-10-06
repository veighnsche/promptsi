import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_reply.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/models/mixins/with_owner.dart';
import 'package:prompts_game/services/apis/profile_api.dart';
import 'package:prompts_game/services/apis/reply_api.dart';

class AppPrompt with WithDocumentReference, WithOwner {
  AppPrompt({
    required this.ownerId,
    required this.madeById,
    required this.prompt,
  });

  @override
  final String ownerId;
  final String madeById;
  final String prompt;

  AppProfile? _madeBy;
  AppReply? _myReply;
  List<AppReply>? _replies;

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
    return _myReply = await ReplyApi.fetchMyReply(reference);
  }

  Future<AppReply> addReply(String reply) async {
    return _myReply = await ReplyApi.create(reference, reply);
  }


  /// can be null, if there are no replies
  Future<List<AppReply>?> get replies async {
    if (_replies != null) {
      return _replies!;
    }
    return _replies = await ReplyApi.fetchReplies(reference);
  }

  AppPrompt.fromJson(Map<String, dynamic> json)
      : ownerId = json['ownerId'],
        madeById = json['madeById'],
        prompt = json['prompt'];

  AppPrompt.fromJsonPreMade(Map<String, dynamic> json)
      : ownerId = json['madeById'],
        madeById = json['madeById'],
        prompt = json['prompt'];

  Map<String, dynamic> toJson() => {
        'ownerId': ownerId,
        'madeById': madeById,
        'prompt': prompt,
      };

  Map<String, dynamic> toJsonPreMade() => {
        'madeById': madeById,
        'prompt': prompt,
      };
}
