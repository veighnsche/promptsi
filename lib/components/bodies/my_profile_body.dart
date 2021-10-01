import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/loading_body.dart';
import 'package:prompts_game/models/profile_model.dart';
import 'package:prompts_game/services/apis/storage_api.dart';

class MyProfileBody extends StatefulWidget {
  const MyProfileBody({Key? key, required this.profile}) : super(key: key);

  final AppProfile profile;

  @override
  State<StatefulWidget> createState() => _MyProfileBodyState();
}

class _MyProfileBodyState extends State<MyProfileBody> {
  String get name {
    return widget.profile.firstName;
  }

  String get age {
    return widget.profile.age;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: FutureBuilder(
            future: StorageApi.fetchUserPictureUrls(widget.profile.userId),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              if (snapshot.connectionState == ConnectionState.done) {
                final List<String> listResult = snapshot.data!;
                return Column(
                  children: listResult.map((e) => Image.network(e)).toList(),
                );
              }

              return const LoadingBody();
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '$name, $age',
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
