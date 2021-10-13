import 'package:flutter/material.dart';
import 'package:prompts_game/components/scaffolds/chat_scaffold.dart';
import 'package:prompts_game/components/scaffolds/profile_scaffold.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat_tile.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';

class NavigatorUtils {
  static void goToProfile(BuildContext context, AppProfile owner) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ProfileScaffold(profile: owner),
      ),
    );
  }

  static void openChat(BuildContext context, AppChatTile chatTile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ChatScaffold(chatTile: chatTile),
      ),
    );
  }
}
