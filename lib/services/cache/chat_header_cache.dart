import 'package:prompts_game/models/app_chat.dart';

class ChatHeaderCache {
  factory ChatHeaderCache() => _instance;
  static final ChatHeaderCache _instance = ChatHeaderCache._internal();

  ChatHeaderCache._internal();

  final Map<String, AppChatHeader> _chatHeaders = {};

  bool has(String profileId) {
    return _chatHeaders[profileId] != null;
  }

  void add(AppChatHeader chatHeader) {
    if (!has(chatHeader.id) || canSet()) {
      print('setting chatHeader ${chatHeader.id}');
      _chatHeaders[chatHeader.id] = chatHeader;
    }
  }

  AppChatHeader get(String profileId) {
    return _chatHeaders[profileId]!;
  }

  bool canSet() => false;
}
