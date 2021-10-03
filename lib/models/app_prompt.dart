import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/services/apis/profile_api.dart';

class AppPrompt {
  AppPrompt({
    required this.ownerId,
    required this.prompt,
    required this.madeByUserId,
    this.isPreMade,
  });

  final String ownerId;
  final String prompt;
  final String madeByUserId;
  final bool? isPreMade;

  DocumentReference? reference;
  AppProfile? owner;
  AppProfile? madeBy;

  String get madeByString {
    return 'Made by ${madeBy!.firstName}';
  }

  Future<void> fetchMadeByProfile() {
    return ProfileApi.fetchProfile(madeByUserId).then((AppProfile? profile) {
      if (profile == null) {
        throw 'no profile';
      }
      madeBy = profile;
    });
  }

  Future<void> fetchOwnerProfile() {
    return ProfileApi.fetchProfile(ownerId).then((AppProfile? profile) {
      if (profile == null) {
        throw 'no profile';
      }
      owner = profile;
    });
  }

  AppPrompt.fromJson(Map<String, dynamic> json)
      : ownerId = json['ownerId'] ?? json['userId'],
        // @deprecated 'userId'
        prompt = json['prompt'],
        madeByUserId = json['madeBy'],
        isPreMade = json['isPreMade'];

  Map<String, dynamic> toJson() => {
        'ownerId': ownerId,
        'prompt': prompt,
        'madeBy': madeByUserId,
        'isPreMade': isPreMade,
      };
}
