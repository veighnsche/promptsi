import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/error_body.dart';
import 'package:prompts_game/components/widgets/app_stream_builder.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';
import 'package:prompts_game/services/apis/chat_api.dart';

class ChatListBody extends StatefulWidget {
  const ChatListBody({Key? key, required this.profile}) : super(key: key);

  final AppProfile profile;

  @override
  State<ChatListBody> createState() => _ChatListBodyState();
}

class _ChatListBodyState extends State<ChatListBody> {
  @override
  Widget build(BuildContext context) {
    return AppStreamBuilder(
        stream: ChatApi(widget.profile.reference).streamChatList,
        builder: (context, List<AppChatHeader>? chatList) {
          if (chatList == null) {
            return const ErrorBody('No chats yet!');
          }
          return const SizedBox.shrink();
        });
  }
}
