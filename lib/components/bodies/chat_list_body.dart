import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/error_body.dart';
import 'package:prompts_game/components/builders/app_stream_builder.dart';
import 'package:prompts_game/models/documents/app_chat_tile/app_chat_tile.dart';
import 'package:prompts_game/services/apis/chat_tiles_api.dart';

class ChatListBody extends StatefulWidget {
  const ChatListBody({Key? key}) : super(key: key);

  @override
  State<ChatListBody> createState() => _ChatListBodyState();
}

class _ChatListBodyState extends State<ChatListBody> {
  @override
  Widget build(BuildContext context) {
    return AppStreamBuilder(
        stream: ChatTilesApi.streamChatTiles,
        builder: (context, List<AppChatTile>? chatList) {
          if (chatList == null) {
            return const ErrorBody('No chats yet!');
          }
          return const SizedBox.shrink();
        });
  }
}
