import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/models/mixins/with_owner.dart';
import 'package:prompts_game/services/apis/replies_api.dart';

class AppReply with WithDocumentReference, WithOwner {
  AppReply({required this.reply, this.reaction});

  AppReply.create(this.reply);

  final String reply;
  int? reaction;

  @override
  get ownerId {
    return reference.id;
  }

  void react(int reactionIdx) {
    if (reaction != reactionIdx) {
      reaction = reactionIdx == -1 ? null : reactionIdx;
      RepliesApi.react(this);
    }
  }

  AppReply.fromJson(Map<String, dynamic> json)
      : reply = json['reply'],
        reaction = json['reaction'];

  Map<String, dynamic> toJson() => {
        'reply': reply,
        'reaction': reaction,
        'createdOn': DateTime.now().millisecondsSinceEpoch,
      };
}
