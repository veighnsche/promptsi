import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/error_body.dart';
import 'package:prompts_game/components/builders/app_future_builder.dart';
import 'package:prompts_game/components/builders/app_stream_builder.dart';
import 'package:prompts_game/components/widgets/profile_picture.dart';
import 'package:prompts_game/models/documents/app_chat/app_chat.dart';
import 'package:prompts_game/models/documents/app_match/app_match.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';
import 'package:prompts_game/models/mixins/with_document_reference.dart';
import 'package:prompts_game/services/apis/matches_api.dart';
import 'package:prompts_game/utils/navigator_utils.dart';

class MatchesBody extends StatelessWidget {
  const MatchesBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStreamBuilder(
      stream: MatchesApi.streamMatches,
      builder: (context, List<AppMatch>? matchList) {
        if (matchList == null) {
          return const ErrorBody('No matches yet!');
        }
        return ListView(
          children: matchList.map((AppMatch match) {
            return ListTile(
              onTap: () {
                Future.wait([
                  match.ownerAsync,
                  match.chatAsync,
                ]).then((List<WithDocumentReference> tuple) {
                  NavigatorUtils.openChat(
                    context,
                    profile: tuple[0] as AppProfile,
                    chat: tuple[1] as AppChat,
                  );
                });
              },
              leading: ProfilePicture(
                pictureUint8ListAsync: match.profilePictureAsync,
                pictureUint8List: match.profilePicture,
              ),
              trailing: Text(
                match.timeAgo,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              title: AppFutureBuilder.skipFuture(
                future: match.ownerAsync,
                initialData: match.owner,
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
