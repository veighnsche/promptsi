import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/app_reply.dart';
import 'package:prompts_game/services/apis/firebase/auth_api.dart';
import 'package:prompts_game/services/cache/replies_cache.dart';

class RepliesApi {
  RepliesApi(this.promptRef);

  final DocumentReference promptRef;
  final RepliesCache _repliesCache = RepliesCache();

  CollectionReference get _repliesRef {
    return promptRef.collection('replies').withConverter<AppReply>(
      toFirestore: (AppReply reply, _) => reply.toJson(),
      fromFirestore: (snapshot, _) {
        return AppReply.fromJson(snapshot.data()!)
          ..reference = snapshot.reference;
      },
    );
  }

  Future<AppReply?> get fetchMyReply async {
    if (!_repliesCache.exists(promptRef.id, AuthApi.uid)) {
      return _repliesRef.doc(AuthApi.uid).get().then((
          DocumentSnapshot snapshot) {
        if (!snapshot.exists) {
          /// could be nullable, because user hasn't replied to a prompt
          return null;
        }

        return _handleDocumentSnapshot(snapshot);
      });
    }
    return _repliesCache.getMyReply(promptRef.id);
  }

  Future<List<AppReply>?> get fetchReplies async {
    if (!_repliesCache.has(promptRef.id)) {
      return _repliesRef.orderBy('createdOn').get().then(_handleQuerySnapshot);
    }
    return _repliesCache.get(promptRef.id);
  }

  Stream<List<AppReply>?> get streamReplies {
    print('start reply stream $promptRef');
    return _repliesRef
        .orderBy('createdOn')
        .snapshots()
        .map(_handleQuerySnapshot);
  }

  Future<AppReply> create(String replyText) async {
    final AppReply replyBody = AppReply.create(replyText);
    final DocumentReference ref = _repliesRef.doc(AuthApi.uid);
    await ref.set(replyBody);
    return ref.get().then(_handleDocumentSnapshot);
  }

  List<AppReply>? _handleQuerySnapshot(QuerySnapshot snapshot) {
    if (snapshot.docs.isEmpty) {
      /// could be nullable, because prompt doesn't have any replies
      return null;
    }

    return snapshot.docs.map(_handleDocumentSnapshot).toList();
  }

  AppReply _handleDocumentSnapshot(DocumentSnapshot doc) {
    AppReply reply = doc.data() as AppReply;
    _repliesCache.add(promptRef.id, reply);
    return reply;
  }

  static void react(AppReply reply)  {
    reply.reference.update({'reaction': reply.reaction});
  }
}
