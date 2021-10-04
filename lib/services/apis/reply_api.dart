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
  ) {
    AppReply reply = AppReply.create(replyText);
    return _repliesRef(promptRef)
        .add(reply)
        .then((DocumentReference ref) => ref.get())
        .then((DocumentSnapshot snapshot) => snapshot.data() as AppReply);
  }

  static Future<AppReply?> querySingleReply(Query query) {
    return query.get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.isEmpty) {
        return null;
      }

      DocumentSnapshot doc = snapshot.docs.elementAt(0);
      AppReply reply = doc.data() as AppReply;
      return reply.hydrate(doc.reference);
    });
  }

  static Future<AppReply?> fetchMyReply(DocumentReference promptRef) {
    return querySingleReply(
      _repliesRef(promptRef).where('ownerId', isEqualTo: AuthApi.uid),
    );
  }
}
