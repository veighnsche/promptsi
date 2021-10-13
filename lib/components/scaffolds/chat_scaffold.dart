import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/error_body.dart';
import 'package:prompts_game/components/bubbles/bubble_current_user.dart';
import 'package:prompts_game/components/bubbles/bubble_other_user.dart';
import 'package:prompts_game/components/builders/app_future_builder.dart';
import 'package:prompts_game/components/builders/app_stream_builder.dart';
import 'package:prompts_game/components/forms/chat/chat_form.dart';
import 'package:prompts_game/components/widgets/profile_picture.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat_message.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat_tile.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';

class ChatScaffold extends StatelessWidget {
  const ChatScaffold({Key? key, required this.chatTile}) : super(key: key);

  final AppChatTile chatTile;

  @override
  Widget build(BuildContext context) {
    return AppFutureBuilder(
      future: chatTile.chatAsync,
      builder: (context, AppChat chat) {
        return Scaffold(
          appBar: AppBar(
            title: Transform.translate(
              offset: const Offset(-35, 0),
              child: AppFutureBuilder.skipFuture(
                future: chatTile.ownerAsync,
                initialData: chatTile.owner,
                builder: (context, AppProfile owner) {
                  return Row(
                    children: [
                      SizedBox(
                        height: 55,
                        width: 55,
                        child: ProfilePicture(
                          pictureUint8ListAsync: owner.profilePictureAsync,
                          pictureUint8List: owner.profilePicture,
                        ),
                      ),
                      Text(owner.firstName),
                    ],
                  );
                },
              ),
            ),
          ),
          body: Column(
            children: [
              Flexible(child: ChatBody(chat: chat)),
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
                child: ChatForm(
                  onMessageSend: (String message) {
                    return chat.sendMessage(message);
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

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
