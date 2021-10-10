import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/models/mixins/with_owner.dart';

class AppReply with WithDocumentReference, WithOwner {
  AppReply({required this.reply});

  AppReply.create(this.reply);

  @override
  get ownerId {
    return reference.id;
  }

  final String reply;

  AppReply.fromJson(Map<String, dynamic> json) : reply = json['reply'];

  Map<String, dynamic> toJson() => {
        'reply': reply,
        'createdOn': DateTime.now().millisecondsSinceEpoch,
      };
}
