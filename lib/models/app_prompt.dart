import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/services/apis/profile_api.dart';

class AppPrompt {
  AppPrompt({
    required this.userId,
    required this.prompt,
    required this.madeByUserId,
    this.isPreMade,
  });

  final String userId;
  final String prompt;
  final String madeByUserId;
  final bool? isPreMade;

  DocumentReference? reference;
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

  AppPrompt.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        prompt = json['prompt'],
        madeByUserId = json['madeBy'],
        isPreMade = json['isPreMade'];

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'prompt': prompt,
    'madeBy': madeByUserId,
    'isPreMade': isPreMade,
  };
}
