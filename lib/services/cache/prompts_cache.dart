import 'package:prompts_game/models/documents/app_prompt/app_prompt.dart';
import 'package:prompts_game/services/cache/mixins/nested_map_cache.dart';

class PromptsCache extends NestedMapCache<AppPrompt> {
  factory PromptsCache() => _instance;
  static final PromptsCache _instance = PromptsCache._internal();

  PromptsCache._internal();

  @override
  bool canReplace(
    String parentId,
    String id,
    AppPrompt value,
    AppPrompt cache,
  ) {
    return cache.prompt != value.prompt;
  }
}
