import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_reply.dart';
import 'package:prompts_game/services/apis/profile_api.dart';
import 'package:prompts_game/services/apis/reply_api.dart';

class AppPrompt {
  AppPrompt({
    required this.ownerId,
    required this.madeById,
    required this.prompt,
  });

  final String ownerId;
  final String madeById;
  final String prompt;

  DocumentReference? reference;
  AppProfile? owner;
  AppProfile? madeBy;
  AppReply? myReply;
  List<AppReply>? replies;

  @override
  String toString() {
    return reference!.id;
  }

  String get madeByString {
    return 'Made by ${madeBy!.firstName}';
  }

  Future<AppPrompt> hydrate(DocumentReference ref) async {
    reference = ref;
    await fetchMadeByProfile();
    await fetchOwnerProfile();
    await fetchMyReply();
    return this;
  }

  Future<AppProfile?> fetchOwnerProfile() async {
    if (owner != null) {
      return owner;
    }
    return owner = await ProfileApi.fetchProfile(ownerId, withPictures: true)
        .then((AppProfile? profile) {
      if (profile == null) {
        throw 'no owner profile';
      }
      return profile;
    });
  }

  Future<AppProfile?> fetchMadeByProfile() async {
    if (madeBy != null) {
      return madeBy;
    }
    return madeBy = await ProfileApi.fetchProfile(madeById).then(
      (AppProfile? profile) {
        if (profile == null) {
          throw 'no made by profile';
        }
        return profile;
      },
    );
  }

  Future<AppReply?> fetchMyReply() async {
    if (myReply != null) {
      return myReply;
    }
    return myReply = await ReplyApi.fetchMyReply(reference!);
  }

  Future<AppReply> addReply(String reply) async {
    return myReply = await ReplyApi.create(reference!, reply);
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
