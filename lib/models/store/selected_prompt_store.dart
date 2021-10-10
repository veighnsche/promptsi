import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:prompts_game/models/app_prompt.dart';

class SelectedPromptStore extends ChangeNotifier {
  final List<AppPrompt> _prompts = [];

  UnmodifiableListView<AppPrompt> get prompts => UnmodifiableListView(_prompts);

  AppPrompt? get prompt {
    if (_prompts.isEmpty) {
      return null;
    }
    return _prompts.first;
  }

  bool get hasMyReply {
    if (_prompts.isEmpty) {
      return false;
    }
    if (prompt!.hasMyReply) {
      return true;
    }
    return false;
  }

  void change(AppPrompt? item) {
    _prompts.clear();
    if (item != null) {
      _prompts.add(item);
    }
    notifyListeners();
  }
}
