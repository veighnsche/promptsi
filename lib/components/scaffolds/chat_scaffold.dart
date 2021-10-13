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
import 'package:prompts_game/services/apis/firebase/auth_api.dart';

class ChatScaffold extends StatefulWidget {
  const ChatScaffold({Key? key, required this.chatTile}) : super(key: key);

  final AppChatTile chatTile;

  @override
  State<ChatScaffold> createState() => _ChatScaffoldState();
}

class _ChatScaffoldState extends State<ChatScaffold> {
  @override
  Widget build(BuildContext context) {
    AppBar _appBar = AppBar(
      title: Transform.translate(
        offset: const Offset(-35, 0),
        child: AppFutureBuilder.skipFuture(
          future: widget.chatTile.ownerAsync,
          initialData: widget.chatTile.owner,
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
    );

    return Scaffold(
      appBar: _appBar,
      body: AppFutureBuilder(
        future: widget.chatTile.chatAsync,
        builder: (context, AppChat chat) {
          final Iam iam = chat.user1 == AuthApi.uid ? Iam.user1 : Iam.user2;

          return AppStreamBuilder(
            stream: chat.messagesStream,
            builder: (context, List<AppChatMessage>? messages) {
              if (messages == null) {
                return const ErrorBody('no messages yet');
              }
              return throw ListView(
                reverse: true,
                children: messages.map((AppChatMessage message) {
                  if (message.user1Message != null) {
                    if (iam == Iam.user1) {
                      return BubbleCurrentUser(text: message.user1Message!);
                    }
                    return BubbleOtherUser.onChat(text: message.user1Message!);
                  }
                  if (iam == Iam.user2) {
                    return BubbleCurrentUser(text: message.user2Message!);
                  }
                  return BubbleOtherUser.onChat(text: message.user2Message!);
                }).toList(),
              );
            }
          );
        }
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ChatForm(
          onMessageSend: (_) async {},
        ),
      ),
    );
  }
}

enum Iam { user1, user2 }
