import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/error_body.dart';
import 'package:prompts_game/components/widgets/app_future_builder.dart';
import 'package:prompts_game/components/widgets/carousel_profiles.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';
import 'package:prompts_game/services/apis/profile_api.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key, required this.profile}) : super(key: key);

  final AppProfile profile;

  @override
  Widget build(BuildContext context) {
    return AppFutureBuilder(
      future: ProfileApi.fetchMatchingProfiles(profile),
      builder: (context, List<AppProfile>? profiles) {
        if (profiles == null) {
          return const ErrorBody('No profiles');
        }
        return CarouselProfiles(profiles: profiles);
      },
    );
  }
}
