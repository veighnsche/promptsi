import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/models/mixins/with_owner.dart';
import 'package:prompts_game/services/apis/auth_api.dart';

class AppReply with WithDocumentReference, WithOwner {
  AppReply({required this.ownerId, required this.reply});

  AppReply.create(this.reply) : ownerId = AuthApi.uid;

  @override
  final String ownerId;
  final String reply;

  AppReply.fromJson(Map<String, dynamic> json)
      : ownerId = json['ownerId'],
        reply = json['reply'];

  Map<String, dynamic> toJson() => {
        'ownerId': ownerId,
        'reply': reply,
      };
}
