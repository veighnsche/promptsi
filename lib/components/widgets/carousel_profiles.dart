import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/profile_body.dart';
import 'package:prompts_game/models/app_profile.dart';
import 'package:prompts_game/store/selected_prompt_store.dart';
import 'package:provider/provider.dart';

class CarouselProfiles extends StatefulWidget {
  const CarouselProfiles({Key? key, required this.profiles}) : super(key: key);

  final List<AppProfile> profiles;

  @override
  State<CarouselProfiles> createState() => _CarouselProfilesState();
}

class _CarouselProfilesState extends State<CarouselProfiles> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: CarouselSlider(
        items: widget.profiles.map((AppProfile profile) {
          return ChangeNotifierProvider(
            create: (context) => SelectedPromptStore(),
            child: Card(
              child: ProfileBody(
                profile: profile,
                type: ProfileBodyType.onFeed,
              ),
            ),
          );
        }).toList(),
        options: CarouselOptions(
          viewportFraction: 0.95,
          height: double.infinity,
        ),
      ),
    );
  }
}
