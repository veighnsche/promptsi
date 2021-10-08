import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/services/apis/auth_api.dart';

class PromptsApi {
  PromptsApi(this.profileRef);

  final DocumentReference profileRef;

  CollectionReference get _promptsRef {
    return profileRef.collection('prompts').withConverter<AppPrompt>(
          toFirestore: (AppPrompt prompt, _) => prompt.toJson(),
          fromFirestore: (snapshot, _) {
            return AppPrompt.fromJson(snapshot.data()!)
              ..reference = snapshot.reference;
          },
        );
  }

  static AppPrompt _handleDocumentSnapshot(DocumentSnapshot doc) {
    return doc.data() as AppPrompt;
  }

  static List<AppPrompt>? _handleQuerySnapshot(QuerySnapshot snapshot) {
    if (snapshot.docs.isEmpty) {
      /// can be nullable
      return null;
    }

    return snapshot.docs.map(_handleDocumentSnapshot).toList();
  }

  Future<List<AppPrompt>?> get prompts {
    /// can be nullable if the user doesn't have any prompts
    return _promptsRef.get().then(_handleQuerySnapshot);
  }

  Stream<List<AppPrompt>?> get promptStream {
    /// can be nullable if the user doesn't have any prompts
    return _promptsRef.snapshots().map(_handleQuerySnapshot);
  }

  Future<AppPrompt> createPrompt(String promptText, {String? madeById}) {
    AppPrompt prompt = AppPrompt(
      madeById: madeById ?? AuthApi.uid,
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

  Future<AppPrompt> createRePrompt(
    String promptText,
    String madeById,
  ) {
    return createPrompt(promptText, madeById: madeById);
  }
}
