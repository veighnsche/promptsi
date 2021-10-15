import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prompts_game/components/builders/app_future_builder.dart';
import 'package:prompts_game/components/widgets/blur_layer.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';

class CarouselPictures extends StatefulWidget {
  const CarouselPictures({Key? key, required this.profile}) : super(key: key);

  final AppProfile profile;

  @override
  State<CarouselPictures> createState() => _CarouselPicturesState();
}

class _CarouselPicturesState extends State<CarouselPictures> {
  int position = 0;

  void _onPageChanged(int next, _) {
    setState(() {
      position = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: width + 20,
      child: AppFutureBuilder.skipFuture(
        future: widget.profile.hasMatchAsync,
        initialData: widget.profile.hasMatch,
        builder: (context, bool hasMatch) {
          return AppFutureBuilder.skipFuture(
            future: widget.profile.picturesAsync,
            initialData: widget.profile.pictures,
            builder: (context, List<String> pictures) {
              return Column(
                children: [
                  CarouselSlider(
                    items: pictures.map((url) {
                      return ClipRect(
                        child: Stack(
                          children: [
                            CachedNetworkImage(imageUrl: url),
                            if (!hasMatch) const BlurLayer(sigma: 16),
                          ],
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      aspectRatio: 1,
                      viewportFraction: 1,
                      enableInfiniteScroll: false,
                      onPageChanged: _onPageChanged,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pictures.length,
                      (index) {
                        return FaIcon(
                          position == index
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 12,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
