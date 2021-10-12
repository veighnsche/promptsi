import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/error_body.dart';
import 'package:prompts_game/components/builders/app_future_builder.dart';
import 'package:prompts_game/components/builders/app_stream_builder.dart';
import 'package:prompts_game/components/scaffolds/chat_scaffold.dart';
import 'package:prompts_game/components/widgets/profile_picture.dart';
import 'package:prompts_game/models/documents/app_chat_tile/app_chat_tile.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';
import 'package:prompts_game/services/apis/chat_tiles_api.dart';

class ChatTilesBody extends StatefulWidget {
  const ChatTilesBody({Key? key}) : super(key: key);

  @override
  State<ChatTilesBody> createState() => _ChatTilesBodyState();
}

class _ChatTilesBodyState extends State<ChatTilesBody> {
  void _openChat(AppChatTile chatTile) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return ChatScaffold(chatTile: chatTile);
      },
    ));
  }

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
              onTap: () => _openChat(chatTile),
              leading: ProfilePicture(
                pictureUint8ListAsync: chatTile.profilePictureAsync,
                pictureUint8List: chatTile.profilePicture,
              ),
              title: AppFutureBuilder.skipFuture(
                future: chatTile.ownerAsync,
                initialData: chatTile.owner,
                builder: (context, AppProfile owner) {
                  return Text(owner.firstName);
                },
              ),
              subtitle: Text(chatTile.timeAgo),
            );
          }).toList(),
        );
      },
    );
  }
}
