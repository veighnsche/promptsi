import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/models/mixins/with_owner.dart';
import 'package:prompts_game/services/apis/chats_api.dart';
import 'package:prompts_game/utils/date_utils.dart';

class AppChatTile extends WithDocumentReference with WithOwner {
  AppChatTile(
    DocumentReference reference, {
    required this.chatId,
    required this.updatedOn,
  }) : super(reference);

  final String chatId;
  final int updatedOn;

  @override
  String get ownerId => id;

  String get timeAgo => AppDateUtils(updatedOn).timeAgo;

  Future<AppChat> get chatAsync {
    return ChatsApi.fetchChat(chatId);
  }

  AppChatTile.create({required this.chatId, required this.updatedOn})
      : super(null);

  AppChatTile.fromJson(DocumentReference reference, Map<String, dynamic> json)
      : chatId = json['chatId'],
        updatedOn = json['updatedOn'],
        super(reference);

  Map<String, dynamic> get json => {
        'updatedOn': updatedOn,
        'chatId': chatId,
      };
}
