import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/models/mixins/with_owner.dart';
import 'package:prompts_game/services/apis/replies_api.dart';

class AppReply extends WithDocumentReference with WithOwner {
  AppReply(DocumentReference reference, {required this.reply, this.reaction})
      : super(reference);

  AppReply.create(this.reply) : super(null);

  final String reply;
  int? reaction;

  @override
  get ownerId => id;

  void react(int reactionIdx) {
    if (reaction != reactionIdx) {
      owner!.startChatNotExists.whenComplete(() {
        reaction = reactionIdx == -1 ? null : reactionIdx;
        RepliesApi.react(this);
      });
    }
  }

  AppReply.fromJson(DocumentReference reference, Map<String, dynamic> json)
      : reply = json['reply'],
        reaction = json['reaction'],
        super(reference);

  Map<String, dynamic> get json => {
        'reply': reply,
        'reaction': reaction,
        'createdOn': DateTime.now().millisecondsSinceEpoch,
      };
}
