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
    return ref.get().then(
      (DocumentSnapshot snapshot) {
        return snapshot.data() as AppReply..reference = ref;
      },
    );
  }

  static Future<List<AppReply>?> _queryReplies(Query query) {
    return query.get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.isEmpty) {
        /// could be nullable, because prompt doesn't have any replies
        return null;
      }

      return snapshot.docs.map(
        (DocumentSnapshot doc) {
          return doc.data() as AppReply..reference = doc.reference;
        },
      ).toList();
    });
  }

  static Future<AppReply?> _queryReply(Query query) {
    return query.get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.isEmpty) {
        /// could be nullable, because user hasn't replied to a prompt
        return null;
      }

      DocumentSnapshot doc = snapshot.docs.elementAt(0);
      return doc.data() as AppReply..reference = doc.reference;
    });
  }

  static Future<AppReply?> fetchMyReply(DocumentReference promptRef) {
    return _queryReply(
      _repliesRef(promptRef).where('ownerId', isEqualTo: AuthApi.uid),
    );
  }

  static Future<List<AppReply>?> fetchReplies(DocumentReference promptRef) {
    return _queryReplies(_repliesRef(promptRef));
  }
}
