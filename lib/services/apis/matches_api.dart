import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/documents/app_match/app_match.dart';
import 'package:prompts_game/services/apis/profile_api.dart';
import 'package:prompts_game/services/cache/matches_cache.dart';

class MatchesApi {
  static MatchesCache get _matchesCache => MatchesCache();

  static CollectionReference get _matchesRef {
    return ProfileApi.myProfile.reference
        .collection('matches')
        .withConverter<AppMatch>(
          toFirestore: (AppMatch match, _) => match.json,
          fromFirestore: (snapshot, options) {
            return AppMatch.fromJson(snapshot.reference, snapshot.data()!);
          },
        );
  }

  static Stream<List<AppMatch>?> get streamMatches {
    return _matchesRef
        .orderBy('updatedOn', descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }

      return snapshot.docs.map((DocumentSnapshot doc) {
        AppMatch match = doc.data() as AppMatch;
        _matchesCache.add(match);
        return match;
      }).toList();
    });
  }

  static bool hasMatch(String profileId) {
    return _matchesCache.exists(profileId);
  }

  static Future<AppMatch?> fetchMatch(String profileId) async {
    if (!hasMatch(profileId)) {
      return _matchesRef.doc(profileId).get().then((DocumentSnapshot snapshot) {
        if (!snapshot.exists) {
          return null;
        }
        return _handleSnapshot(snapshot);
      });
    }
    return _matchesCache.get(profileId);
  }

  static AppMatch _handleSnapshot(DocumentSnapshot snapshot) {
    AppMatch match = snapshot.data() as AppMatch;
    _matchesCache.add(match);
    return match;
  }
}
