import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/services/apis/prompts_api.dart';
import 'package:prompts_game/services/apis/storage_api.dart';

class AppProfile with WithDocumentReference {
  AppProfile({
    required this.userId,
    required this.firstName,
    required this.age,
    required this.gender,
    required this.interestedIn,
  });

  final String userId;
  final String firstName;
  final String age;
  final AppGenders gender;
  final List<AppGenders> interestedIn;

  List<String>? _pictures;
  List<AppPrompt>? _prompts;

  Future<String> get picture async {
    if (_pictures == null) {
      await pictures;
    }
    return _pictures!.isEmpty
        ? 'https://thesocialstudies.co/wp-content/uploads/2021/06/placeholder-1-1.jpg'
        : _pictures!.elementAt(0);
  }

  Future<List<String>> get pictures async {
    if (_pictures != null) {
      return _pictures!;
    }
    return _pictures = await StorageApi.fetchPictureUrls(userId);
  }

  Future<List<AppPrompt>> get prompts async {
    if (_prompts != null) {
      return _prompts!;
    }
    return _prompts = await PromptsApi.fetchUserPrompts(userId);
  }

  AppProfile.create({
    required this.userId,
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
  })  : userId = profile.firstName,
        firstName = firstName ?? profile.firstName,
        age = age ?? profile.age,
        gender = gender ?? profile.gender,
        interestedIn = interestedIn ?? profile.interestedIn;

  AppProfile.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        firstName = json['firstName'],
        age = json['age'] ?? '',
        gender = AppGenders.values.elementAt(json['gender'] ?? 0),
        interestedIn = (json['interestedIn'] ?? [])
            .map<AppGenders>((val) => AppGenders.values.elementAt(val))
            .toList();

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'firstName': firstName,
        'age': age,
        'gender': gender.index,
        'interestedIn': interestedIn.map((AppGenders g) => g.index).toList(),
      };
}

enum AppGenders {
  undefined,
  woman,
  man,
  neutral,
}
