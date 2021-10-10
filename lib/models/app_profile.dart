import 'dart:typed_data';

import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/services/apis/prompts_api.dart';
import 'package:prompts_game/services/apis/firebase/storage_api.dart';
import 'package:prompts_game/services/cache/pictures_cache.dart';
import 'package:prompts_game/services/cache/profile_pictures_cache.dart';
import 'package:prompts_game/services/cache/prompts_cache.dart';

class AppProfile with WithDocumentReference {
  AppProfile({
    required this.firstName,
    required this.age,
    required this.gender,
    required this.interestedIn,
  });

  final String firstName;
  final String age;
  final AppGenders gender;
  final List<AppGenders> interestedIn;

  final ProfilePicturesCache _profilePicturesCache = ProfilePicturesCache();
  final PicturesCache _picturesCache = PicturesCache();
  final PromptsCache _promptsCache = PromptsCache();

  PromptsApi get _promptsApi => PromptsApi(reference);

  Uint8List? get profilePicture {
    if (!_profilePicturesCache.has(reference.id)) {
      return null;
    }
    return _profilePicturesCache.get(reference.id);
  }

  Future<Uint8List> get profilePictureAsync async {
    return StorageApi.fetchProfilePicture(id);
  }

  List<String>? get pictures {
    if (!_picturesCache.has(reference.id)) {
      return null;
    }
    return _picturesCache.get(reference.id);
  }

  Future<List<String>> get picturesAsync async {
    return StorageApi.fetchPictureUrls(id);
  }

  List<int> get listedInterestedIn {
    return interestedIn.map((AppGenders g) => g.index).toList();
  }

  List<AppPrompt>? get prompts {
    if (!_promptsCache.has(id)) {
      return null;
    }
    return _promptsCache.get(id);
  }

  Stream<List<AppPrompt>?> get promptStream {
    return _promptsApi.promptStream;
  }

  AppProfile.create({
    String? firstName,
    String? age,
    AppGenders? gender,
    List<AppGenders>? interestedIn,
  })  : firstName = firstName ?? '',
        age = age ?? '',
        gender = gender ?? AppGenders.undefined,
        interestedIn = interestedIn ?? [];

  AppProfile.edit(
    AppProfile profile, {
    String? firstName,
    String? age,
    AppGenders? gender,
    List<AppGenders>? interestedIn,
  })  : firstName = firstName ?? profile.firstName,
        age = age ?? profile.age,
        gender = gender ?? profile.gender,
        interestedIn = interestedIn ?? profile.interestedIn;

  AppProfile.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'],
        age = json['age'] ?? '',
        gender = AppGenders.values.elementAt(json['gender'] ?? 0),
        interestedIn = (json['interestedIn'] ?? [])
            .map<AppGenders>((val) => AppGenders.values.elementAt(val))
            .toList();

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'age': age,
        'gender': gender.index,
        'interestedIn': listedInterestedIn,
      };
}

enum AppGenders {
  undefined,
  woman,
  man,
  neutral,
}
