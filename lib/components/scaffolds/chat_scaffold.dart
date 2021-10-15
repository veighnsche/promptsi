import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prompts_game/components/bodies/chat_body.dart';
import 'package:prompts_game/components/forms/chat/chat_form.dart';
import 'package:prompts_game/components/widgets/profile_picture.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';
import 'package:prompts_game/utils/navigator_utils.dart';

class ChatScaffold extends StatefulWidget {
  const ChatScaffold({Key? key, required this.profile, this.chat})
      : super(key: key);

  final AppProfile profile;
  final AppChat? chat;

  @override
  State<ChatScaffold> createState() => _ChatScaffoldState();
}

class _ChatScaffoldState extends State<ChatScaffold> {
  AppChat? _chat;

  AppChat? get chat {
    return widget.chat ?? _chat;
  }

  set chat(AppChat? chat) {
    _chat = chat;
  }

  Future<void> _onMessageSend(String message) {
    if (chat == null) {
      return widget.profile.startChat.then((AppChat newChat) {
        newChat.sendMessage(message).whenComplete(() {
          setState(() {
            chat = newChat;
          });
        });
      });
    }
    return chat!.sendMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Transform.translate(
          offset: const Offset(-35, 0),
          child: GestureDetector(
            onTap: () => NavigatorUtils.goToProfile(context, widget.profile),
            child: Row(
              children: [
                SizedBox(
                  height: 55,
                  width: 55,
                  child: ProfilePicture(profile: widget.profile),
                ),
                Text(widget.profile.firstName),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: chat == null ? const LockedChat() : ChatBody(chat: chat!),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
            child: ChatForm(
              onMessageSend: _onMessageSend,
            ),
          )
        ],
      ),
    );
  }
}

class LockedChat extends StatelessWidget {
  const LockedChat({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(
          FontAwesomeIcons.lock,
          color: Colors.blueGrey.withOpacity(0.5),
          size: 64,
        ),
        const SizedBox(height: 16),
        const Text(
          'Send a message to unlock each others profiles',
        ),
      ],
    );
  }
}
