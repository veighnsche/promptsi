import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/models/mixins/with_owner.dart';
import 'package:prompts_game/services/apis/chats_api.dart';
import 'package:prompts_game/utils/date_utils.dart';

class AppMatch extends WithDocumentReference with WithOwner {
  AppMatch(
    DocumentReference reference, {
    required this.chatId,
    required this.createdOn,
    required this.updatedOn,
  }) : super(reference);

  final String chatId;
  final int createdOn;
  final int updatedOn;

  @override
  String get ownerId => id;

  String get timeAgo => AppDateUtils(createdOn).timeAgo;

  Future<AppChat> get chatAsync => ChatsApi.fetchChat(chatId);

  AppMatch.create({required this.createdOn})
      : updatedOn = createdOn,
        chatId = '',
        super(null);

  AppMatch.fromJson(DocumentReference reference, Map<String, dynamic> json)
      : chatId = json['chatId'],
        createdOn = json['createdOn'],
        updatedOn = json['updatedOn'],
        super(reference);

  Map<String, dynamic> get json => {
        'updatedOn': updatedOn,
        'createdOn': createdOn,
        'chatId': chatId,
      };
}
