import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/services/apis/profile_api.dart';

class AppPrompt {
  AppPrompt({
    required this.userId,
    required this.prompt,
    required this.madeBy,
    this.isPreMade,
  });

  final String userId;
  final String prompt;
  final String madeBy;
  final bool? isPreMade;

  DocumentReference? reference;
  AppProfile? madeByProfile;

  Future<void> fetchMadeByProfile() {
    return ProfileApi.fetchProfile(madeBy).then((AppProfile? profile) {
      if (profile == null) {
        throw 'no profile';
      }
      madeByProfile = profile;
    });
  }

  AppPrompt.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        prompt = json['prompt'],
        madeBy = json['madeBy'],
        isPreMade = json['isPreMade'];

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'prompt': prompt,
    'madeBy': madeBy,
    'isPreMade': isPreMade,
  };
}
