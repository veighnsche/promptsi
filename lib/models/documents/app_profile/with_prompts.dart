import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/documents/app_prompt/app_prompt.dart';
import 'package:prompts_game/services/apis/prompts_api.dart';
import 'package:prompts_game/services/cache/prompts_cache.dart';

mixin WithPrompts {
  DocumentReference get reference;

  String get id;

  PromptsCache get _promptsCache => PromptsCache();

  PromptsApi get _promptsApi => PromptsApi(reference);

  List<AppPrompt>? get prompts {
    if (!_promptsCache.parentHas(id)) {
      return null;
    }
    return _promptsCache.toList(id);
  }

  Stream<List<AppPrompt>?> get promptStream {
    return _promptsApi.promptStream;
  }
}
