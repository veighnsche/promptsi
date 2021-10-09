import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/profile_body.dart';
import 'package:prompts_game/models/app_profile.dart';

class CarouselProfiles extends StatefulWidget {
  const CarouselProfiles({Key? key, required this.profiles}) : super(key: key);

  final List<AppProfile> profiles;

  @override
  State<CarouselProfiles> createState() => _CarouselProfilesState();
}

class _CarouselProfilesState extends State<CarouselProfiles> {
  int _currentProfileIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: CarouselSlider(
        items: widget.profiles.map((AppProfile profile) {
          return Card(
            child: ProfileBody(
              profile: profile,
              type: ProfileBodyType.onFeed,
            ),
          );
        }).toList(),
        options: CarouselOptions(
          viewportFraction: 0.95,
          height: double.infinity,
          onPageChanged: (idx, _) {
            _currentProfileIdx = idx;
          },
        ),
      ),
    );
  }
}
