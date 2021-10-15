import 'package:flutter/material.dart';
import 'package:prompts_game/components/scaffolds/chat_scaffold.dart';
import 'package:prompts_game/components/scaffolds/profile_scaffold.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';
import 'package:prompts_game/models/store/matches_store.dart';
import 'package:provider/provider.dart';

class NavigatorUtils {
  static void goToProfile(BuildContext context, AppProfile owner) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ChangeNotifierProvider(
            create: (context) => MatchesStore(),
            builder: (context, child) => ProfileScaffold(profile: owner),
          );
        },
      ),
    );
  }

  static void openChat(
    BuildContext context, {
    required AppProfile profile,
    required AppChat? chat,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return ChangeNotifierProvider(
          create: (context) => MatchesStore(),
          builder: (context, child) {
            return ChatScaffold(profile: profile, chat: chat);
          },
        );
      }),
    );
  }
}
