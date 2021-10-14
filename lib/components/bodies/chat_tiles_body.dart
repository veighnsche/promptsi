import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/error_body.dart';
import 'package:prompts_game/components/builders/app_future_builder.dart';
import 'package:prompts_game/components/builders/app_stream_builder.dart';
import 'package:prompts_game/components/widgets/profile_picture.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat_tile.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/services/apis/chat_tiles_api.dart';
import 'package:prompts_game/utils/navigator_utils.dart';

class ChatTilesBody extends StatelessWidget {
  const ChatTilesBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStreamBuilder(
      stream: ChatTilesApi.streamChatTiles,
      builder: (context, List<AppChatTile>? chatList) {
        if (chatList == null) {
          return const ErrorBody('No chats yet!');
        }
        return ListView(
          children: chatList.map((AppChatTile chatTile) {
            return ListTile(
              onTap: () {
                Future.wait([
                  chatTile.ownerAsync,
                  chatTile.chatAsync,
                ]).then((List<WithDocumentReference> tuple) {
                  NavigatorUtils.openChat(
                    context,
                    profile: tuple[0] as AppProfile,
                    chat: tuple[1] as AppChat,
                  );
                });
              },
              leading: ProfilePicture(
                pictureUint8ListAsync: chatTile.profilePictureAsync,
                pictureUint8List: chatTile.profilePicture,
              ),
              trailing: Text(
                chatTile.timeAgo,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              title: AppFutureBuilder.skipFuture(
                future: chatTile.ownerAsync,
                initialData: chatTile.owner,
                builder: (context, AppProfile owner) {
                  return Text(owner.firstName);
                },
              ),
              subtitle: const Text('future text preview'),
            );
          }).toList(),
        );
      },
    );
  }
}
