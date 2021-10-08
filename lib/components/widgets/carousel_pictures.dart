import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prompts_game/components/widgets/app_future_builder.dart';

class CarouselPictures extends StatefulWidget {
  const CarouselPictures({
    Key? key,
    required this.picturesAsync,
  }) : super(key: key);

  final Future<List<String>> picturesAsync;

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
      child: AppFutureBuilder(
        future: widget.picturesAsync,
        builder: (context, List<String> pictures) {
          return Column(
            children: [
              CarouselSlider(
                items: pictures.map((url) {
                  return CachedNetworkImage(imageUrl: url);
                }).toList(),
                options: CarouselOptions(
                  scrollDirection: Axis.vertical,
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
      ),
    );
  }
}
