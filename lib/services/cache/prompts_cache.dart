import 'package:prompts_game/models/app_prompt.dart';
import 'package:prompts_game/services/cache/mixins/nested_map_cache.dart';

class PromptsCache extends NestedMapCache<AppPrompt> {
  factory PromptsCache() => _instance;
  static final PromptsCache _instance = PromptsCache._internal();

  PromptsCache._internal();

  final Map<String, Map<String, AppPrompt>> _prompts = {};

  @override
  bool canReplace(
    String parentId,
    AppPrompt map,
    NestedMap<AppPrompt> nestedMap, {
    String? id,
  }) {
    return !exists(parentId, map.id) ||
        _prompts[parentId]![map.id]!.prompt != map.prompt;
  }
}
