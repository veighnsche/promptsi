import 'package:prompts_game/models/app_prompt.dart';

class PromptsCache {
  factory PromptsCache() => _instance;
  static final PromptsCache _instance = PromptsCache._internal();

  PromptsCache._internal();

  final Map<String, Map<String, AppPrompt>> _prompts = {};

  bool has(String profileId) {
    return _prompts[profileId] != null;
  }

  bool exists(String profileId, String promptId) {
    return _prompts[profileId]?[promptId] != null;
  }

  bool canAddPrompt(String profileId, AppPrompt prompt) {
    return !exists(profileId, prompt.id) ||
        _prompts[profileId]![prompt.id]!.prompt != prompt.prompt;
  }

  void add(String profileId, AppPrompt prompt) {
    if (!has(profileId)) {
      _prompts[profileId] = {prompt.id: prompt};
    } else if (canAddPrompt(profileId, prompt)) {
      _prompts[profileId]![prompt.id] = prompt;
    }
  }

  List<AppPrompt> get(String profileId) {
    return _prompts[profileId]!.values.toList();
  }
}
