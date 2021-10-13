import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/chat_body.dart';
import 'package:prompts_game/components/builders/app_future_builder.dart';
import 'package:prompts_game/components/forms/chat/chat_form.dart';
import 'package:prompts_game/components/widgets/profile_picture.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat_tile.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';
import 'package:prompts_game/utils/navigator_utils.dart';

class ChatScaffold extends StatelessWidget {
  const ChatScaffold({Key? key, required this.chatTile}) : super(key: key);

  final AppChatTile chatTile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Transform.translate(
          offset: const Offset(-35, 0),
          child: AppFutureBuilder.skipFuture(
            future: chatTile.ownerAsync,
            initialData: chatTile.owner,
            builder: (context, AppProfile owner) {
              return GestureDetector(
                onTap: () => NavigatorUtils.goToProfile(context, owner),
                child: Row(
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
                ),
              );
            },
          ),
        ),
      ),
      body: AppFutureBuilder(
        future: chatTile.chatAsync,
        builder: (context, AppChat chat) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
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
          );
        },
      ),
    );
  }
}
