import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/error_body.dart';
import 'package:prompts_game/components/bubbles/bubble_current_user.dart';
import 'package:prompts_game/components/bubbles/bubble_other_user.dart';
import 'package:prompts_game/components/builders/app_stream_builder.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat_message.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({
    Key? key,
    required this.chat,
  }) : super(key: key);

  final AppChat chat;

  @override
  Widget build(BuildContext context) {
    return AppStreamBuilder(
      stream: chat.messagesStream,
      builder: (context, List<AppChatMessage>? messages) {
        if (messages == null) {
          return const ErrorBody('no messages yet');
        }
        return ListView(
          reverse: true,
          shrinkWrap: true,
          children: messages.reversed.map((AppChatMessage message) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: message.message[chat.iam] != null
                  ? BubbleCurrentUser(text: message.message[chat.iam]!)
                  : Row(children: [
                      BubbleOtherUser.onChat(text: message.message[chat.you]!),
                      const Flexible(child: SizedBox.shrink()),
                    ]),
            );
          }).toList(),
        );
      },
    );
  }
}
