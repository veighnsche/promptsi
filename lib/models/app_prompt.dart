import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/services/apis/profile_api.dart';

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

  String get madeByString {
    return 'Made by ${madeBy!.firstName}';
  }

  Future<AppProfile?> fetchMadeByProfile() {
    return ProfileApi.fetchProfile(madeById).then((AppProfile? profile) {
      if (profile == null) {
        throw 'no profile';
      }
      return profile;
    });
  }

  Future<AppProfile?> fetchOwnerProfile() {
    return ProfileApi.fetchProfile(ownerId).then((AppProfile? profile) {
      if (profile == null) {
        throw 'no profile';
      }
      return profile;
    });
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
