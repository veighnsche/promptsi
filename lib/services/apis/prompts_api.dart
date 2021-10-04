import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/services/apis/auth_api.dart';

class PromptsApi {
  static final CollectionReference _promptsRef = FirebaseFirestore.instance
      .collection('prompts')
      .withConverter<AppPrompt>(
        fromFirestore: (snapshot, _) => AppPrompt.fromJson(snapshot.data()!),
        toFirestore: (AppPrompt prompt, _) => prompt.toJson(),
      );

  static final CollectionReference _promptsPreMadeRef = FirebaseFirestore
      .instance
      .collection('prompts pre-made')
      .withConverter<AppPrompt>(
        fromFirestore: (snapshot, _) =>
            AppPrompt.fromJsonPreMade(snapshot.data()!),
        toFirestore: (AppPrompt prompt, _) => prompt.toJsonPreMade(),
      );

  static Future<List<AppPrompt>?> queryPrompts(Query query) {
    return query.get().then(
      (QuerySnapshot snapshot) async {
        if (snapshot.docs.isEmpty) {
          return null;
        }

        return Future.wait(snapshot.docs.map<Future<AppPrompt>>(
          (DocumentSnapshot doc) {
            AppPrompt prompt = doc.data() as AppPrompt;
            return prompt.hydrate(doc.reference);
          },
        ).toList());
      },
    );
  }

  static Future<List<AppPrompt>?> fetchPreMadePrompts() {
    return queryPrompts(_promptsPreMadeRef);
  }

  static Future<List<AppPrompt>?> fetchUserPrompts(String userId) {
    return queryPrompts(_promptsRef.where('ownerId', isEqualTo: userId));
  }

  static Future<List<AppPrompt>?> fetchPrompts() {
    return queryPrompts(
      _promptsRef.where('ownerId', isNotEqualTo: AuthApi.uid),
    );
  }

  static Future<void> createListFromPreMade(
    AppProfile profile,
    List<AppPrompt> preMadePrompts,
  ) {
    return Future.wait(preMadePrompts.map((AppPrompt preMadePrompt) {
      return createRePrompt(
        profile,
        preMadePrompt.prompt,
        preMadePrompt.madeById,
      );
    }));
  }

  static Future<AppPrompt?> createRePrompt(
    AppProfile profile,
    String promptText,
    String madeByUserId,
  ) {
    AppPrompt prompt = AppPrompt(
      ownerId: profile.userId,
      prompt: promptText,
      madeById: madeByUserId,
    );

    return _promptsRef
        .add(prompt)
        .then((DocumentReference ref) => ref.get())
        .then((DocumentSnapshot snapshot) => snapshot.data() as AppPrompt);
  }
}
