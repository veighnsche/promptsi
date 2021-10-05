import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/app_reply.dart';
import 'package:prompts_game/services/apis/auth_api.dart';

class ReplyApi {
  static CollectionReference _repliesRef(DocumentReference promptRef) {
    return promptRef.collection('replies').withConverter<AppReply>(
          fromFirestore: (snapshot, _) => AppReply.fromJson(snapshot.data()!),
          toFirestore: (AppReply reply, _) => reply.toJson(),
        );
  }

  static Future<AppReply> create(
    DocumentReference promptRef,
    String replyText,
  ) async {
    AppReply replyBody = AppReply.create(replyText);
    DocumentReference ref = await _repliesRef(promptRef).add(replyBody);
    AppReply reply = await ref.get().then(
          (DocumentSnapshot snapshot) => snapshot.data() as AppReply,
        );
    reply.reference = ref;
    return reply;
  }

  static Future<AppReply?> querySingleReply(Query query) {
    return query.get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.isEmpty) {
        return null;
      }

      DocumentSnapshot doc = snapshot.docs.elementAt(0);
      AppReply reply = doc.data() as AppReply;
      reply.reference = doc.reference;
      return reply;
    });
  }

  static Future<AppReply?> fetchMyReply(DocumentReference promptRef) {
    return querySingleReply(
      _repliesRef(promptRef).where('ownerId', isEqualTo: AuthApi.uid),
    );
  }
}
