import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/models/app_prompt.dart';

class PromptsApi {
  static final CollectionReference _promptsRef = FirebaseFirestore.instance
      .collection('prompts')
      .withConverter<AppPrompt>(
        fromFirestore: (snapshot, _) => AppPrompt.fromJson(snapshot.data()!),
        toFirestore: (AppPrompt prompt, _) => prompt.toJson(),
      );

  static Future<List<AppPrompt>?> fetchPreMadePrompts() {
    return _promptsRef.where('isPreMade', isEqualTo: true).get().then(
      (QuerySnapshot snapshot) async {
        if (snapshot.docs.isEmpty) {
          return null;
        }

        return Future.wait(snapshot.docs.map<Future<AppPrompt>>(
          (DocumentSnapshot doc) async {
            AppPrompt prompt = doc.data() as AppPrompt;
            prompt.reference = doc.reference;
            await prompt.fetchMadeByProfile();
            return prompt;
          },
        ).toList());
      },
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
        preMadePrompt.madeBy,
      );
    }));
  }

  static Future<AppPrompt?> createRePrompt(
    AppProfile profile,
    String promptText,
    String madeByUserId,
  ) {
    AppPrompt prompt = AppPrompt(
      userId: profile.userId,
      prompt: promptText,
      madeBy: madeByUserId,
    );

    return _promptsRef
        .add(prompt)
        .then((DocumentReference ref) => ref.get())
        .then((DocumentSnapshot snapshot) => snapshot.data() as AppPrompt);
  }
}
