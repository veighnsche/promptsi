import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/error_body.dart';
import 'package:prompts_game/components/bodies/loading_body.dart';
import 'package:prompts_game/components/forms/pictures/picture_form.dart';
import 'package:prompts_game/services/apis/auth_api.dart';
import 'package:prompts_game/services/apis/storage_api.dart';

class PictureFormFutureBuilder extends StatefulWidget {
  const PictureFormFutureBuilder({Key? key}) : super(key: key);

  @override
  State<PictureFormFutureBuilder> createState() => _PictureFormFutureBuilderState();
}

class _PictureFormFutureBuilderState extends State<PictureFormFutureBuilder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: StorageApi.fetchPictureUrls(AuthApi.currentUser.uid),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasError) {
          return ErrorBody(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return PictureForm(pictures: snapshot.data!);
        }

        return const LoadingBody();
      },
    );
  }
}
