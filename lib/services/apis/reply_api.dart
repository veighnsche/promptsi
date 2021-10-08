import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/app_reply.dart';
import 'package:prompts_game/services/apis/auth_api.dart';

class ReplyApi {
  ReplyApi(DocumentReference promptRef) {
    _repliesRef = promptRef.collection('replies').withConverter<AppReply>(
          toFirestore: (AppReply reply, _) => reply.toJson(),
          fromFirestore: (snapshot, _) {
            return AppReply.fromJson(snapshot.data()!)
              ..reference = snapshot.reference;
          },
        );
  }

  late CollectionReference _repliesRef;

  Future<AppReply> create(String replyText) async {
    final AppReply replyBody = AppReply.create(replyText);
    final DocumentReference ref = _repliesRef.doc(AuthApi.uid);
    await ref.set(replyBody);
    return ref.get().then(
      (DocumentSnapshot snapshot) {
        return snapshot.data() as AppReply;
      },
    );
  }

  Future<AppReply?> get myReply {
    return _repliesRef.doc(AuthApi.uid).get().then((DocumentSnapshot snapshot) {
      if (!snapshot.exists) {
        /// could be nullable, because user hasn't replied to a prompt
        return null;
      }

      return snapshot.data() as AppReply;
    });
  }

  List<AppReply>? _handleSnapshot(QuerySnapshot snapshot) {
    if (snapshot.docs.isEmpty) {
      /// could be nullable, because prompt doesn't have any replies
      return null;
    }

    return snapshot.docs.map(
          (DocumentSnapshot doc) {
        return doc.data() as AppReply;
      },
    ).toList();
  }

  Future<List<AppReply>?> get replies {
    return _repliesRef.get().then(_handleSnapshot);
  }

  Stream<List<AppReply>?> get replyStream {
    return _repliesRef.snapshots().map(_handleSnapshot);
  }


}
