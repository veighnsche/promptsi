import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/services/apis/firebase/auth_api.dart';
import 'package:prompts_game/services/apis/profile_api.dart';
import 'package:prompts_game/services/cache/prompts_cache.dart';

class PromptsApi {
  PromptsApi(this.profileRef);

  final DocumentReference profileRef;
  final PromptsCache _promptsCache = PromptsCache();

  CollectionReference _toCollectionReference(DocumentReference profileRef) {
    return profileRef.collection('prompts').withConverter<AppPrompt>(
          toFirestore: (AppPrompt prompt, _) => prompt.toJson(),
          fromFirestore: (snapshot, _) {
            return AppPrompt.fromJson(snapshot.data()!)
              ..reference = snapshot.reference;
          },
        );
  }

  CollectionReference get _promptsRef {
    return _toCollectionReference(profileRef);
  }

  AppPrompt _handleDocumentSnapshot(DocumentSnapshot doc) {
    AppPrompt prompt = doc.data() as AppPrompt;
    _promptsCache.add(profileRef.id, prompt);
    return prompt;
  }

  List<AppPrompt>? _handleQuerySnapshot(QuerySnapshot snapshot) {
    if (snapshot.docs.isEmpty) {
      /// can be nullable
      return null;
    }

    return snapshot.docs.map(_handleDocumentSnapshot).toList();
  }

  Stream<List<AppPrompt>?> get promptStream {
    /// can be nullable if the user doesn't have any prompts
    return _promptsRef
        .orderBy('createdOn')
        .snapshots()
        .map(_handleQuerySnapshot);
  }

  Future<AppPrompt> createPrompt(String promptText, {String? madeBy}) {
    AppPrompt prompt = AppPrompt(
      madeById: madeBy ?? AuthApi.uid,
      prompt: promptText,
    );

    return _promptsRef.add(prompt).then(
      (DocumentReference ref) {
        return ref.get().then((DocumentSnapshot snapshot) {
          return snapshot.data() as AppPrompt;
        });
      },
    );
  }

  static Future<AppPrompt> createRePrompt(
    String promptText,
    String madeById,
  ) {
    return ProfileApi.fetchProfile(AuthApi.uid).then((AppProfile? profile) {
      if (profile == null) {
        throw 'can\'t create rePrompt due to not having found own profile';
      }
      return PromptsApi(profile.reference).createPrompt(
        promptText,
        madeBy: madeById,
      );
    });
  }
}
