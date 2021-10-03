import 'package:prompts_game/services/apis/storage_api.dart';

class AppProfile {
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

  String? profilePictureUrl;

  Future<List<String>> fetchPictures() {
    return StorageApi.fetchPictureUrls(userId);
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
