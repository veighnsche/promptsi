import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/documents/app_profile/with_pictures.dart';
import 'package:prompts_game/models/documents/app_profile/with_profile_picture.dart';
import 'package:prompts_game/models/documents/app_profile/with_prompts.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';

class AppProfile extends WithDocumentReference
    with WithProfilePicture, WithPictures, WithPrompts {
  AppProfile(
    DocumentReference reference, {
    required this.firstName,
    required this.age,
    required this.gender,
    required this.interestedIn,
  }) : super(reference);

  final String firstName;
  final String age;
  final AppGenders gender;
  final List<AppGenders> interestedIn;

  List<int> get listedInterestedIn {
    return interestedIn.map((AppGenders g) => g.index).toList();
  }

  AppProfile.create({
    String? firstName,
    String? age,
    AppGenders? gender,
    List<AppGenders>? interestedIn,
  })  : firstName = firstName ?? '',
        age = age ?? '',
        gender = gender ?? AppGenders.undefined,
        interestedIn = interestedIn ?? [],
        super(null);

  AppProfile.edit(
    AppProfile profile, {
    String? firstName,
    String? age,
    AppGenders? gender,
    List<AppGenders>? interestedIn,
  })  : firstName = firstName ?? profile.firstName,
        age = age ?? profile.age,
        gender = gender ?? profile.gender,
        interestedIn = interestedIn ?? profile.interestedIn,
        super(profile.reference);

  AppProfile.fromJson(DocumentReference reference, Map<String, dynamic> json)
      : firstName = json['firstName'],
        age = json['age'] ?? '',
        gender = AppGenders.values.elementAt(json['gender'] ?? 0),
        interestedIn = (json['interestedIn'] ?? [])
            .map<AppGenders>((val) => AppGenders.values.elementAt(val))
            .toList(),
        super(reference);

  Map<String, dynamic> get json => {
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
