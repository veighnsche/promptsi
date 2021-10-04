import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/services/apis/auth_api.dart';
import 'package:prompts_game/services/apis/profile_api.dart';

class AppReply {
  AppReply({required this.ownerId, required this.reply});

  AppReply.create(this.reply) : ownerId = AuthApi.uid;

  final String ownerId;
  final String reply;

  DocumentReference? reference;
  AppProfile? owner;

  Future<AppReply> hydrate(DocumentReference ref) async {
    reference = ref;
    await fetchOwnerProfile();
    return this;
  }

  Future<AppProfile?> fetchOwnerProfile() async {
    if (owner != null) {
      return owner;
    }
    return owner = await ProfileApi.fetchProfile(
      ownerId,
      withPictures: true,
    ).then((AppProfile? profile) {
      if (profile == null) {
        throw 'no owner profile';
      }
      return profile;
    });
  }

  AppReply.fromJson(Map<String, dynamic> json)
      : ownerId = json['ownerId'],
        reply = json['reply'];

  Map<String, dynamic> toJson() => {
        'ownerId': ownerId,
        'reply': reply,
      };
}
