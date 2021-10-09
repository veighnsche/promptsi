import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/services/apis/prompts_api.dart';
import 'package:prompts_game/services/apis/storage_api.dart';

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

  String? _profilePictureBase64;
  List<String>? _pictures;
  List<AppPrompt>? _prompts;

  List<int> get listedInterestedIn {
    return interestedIn.map((AppGenders g) => g.index).toList();
  }

  PromptsApi get _promptsApi => PromptsApi(reference);

  String? get profilePictureBase64 {
    return _profilePictureBase64;
  }

  Future<String> get profilePictureBase64Async async {
    if (_profilePictureBase64 == null) {
      return _profilePictureBase64 =
          await StorageApi.fetchProfilePictureBase64(reference.id);
    }
    return _profilePictureBase64!;
  }

  Future<List<String>> get pictures async {
    if (_pictures == null) {
      return _pictures = await StorageApi.fetchPictureUrls(reference.id);
    }
    return _pictures!;
  }

  Future<List<AppPrompt>?> get prompts async {
    if (_prompts == null) {
      return _prompts = await _promptsApi.prompts;
    }
    return _prompts!;
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
