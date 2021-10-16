import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/profile_other_body_container.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';

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
        options: CarouselOptions(
          viewportFraction: 0.95,
          height: double.infinity,
        ),
        items: widget.profiles.map((AppProfile profile) {
          return Card(child: ProfileOtherBody(profile: profile));
        }).toList(),
      ),
    );
  }
}
