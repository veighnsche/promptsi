import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/error_body.dart';
import 'package:prompts_game/components/builders/app_future_builder.dart';
import 'package:prompts_game/components/forms/chat/chat_form.dart';
import 'package:prompts_game/components/widgets/profile_picture.dart';
import 'package:prompts_game/models/documents/app_chat_tile/app_chat_tile.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';

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
      body: const ErrorBody('No messages yet'),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ChatForm(
          onMessageSend: (_) async {},
        ),
      ),
    );
  }
}
