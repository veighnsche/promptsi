import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PictureCarousel extends StatefulWidget {
  const PictureCarousel({
    Key? key,
    required this.pictures,
    required this.type,
  }) : super(key: key);

  const PictureCarousel.profile({
    Key? key,
    required this.pictures,
    this.type = PictureCarouselType.profile,
  }) : super(key: key);

  const PictureCarousel.home({
    Key? key,
    required this.pictures,
    this.type = PictureCarouselType.home,
  }) : super(key: key);

  final List<String> pictures;
  final PictureCarouselType type;

  @override
  State<PictureCarousel> createState() => _PictureCarouselState();
}

class _PictureCarouselState extends State<PictureCarousel> {
  int position = 0;

  void _onPageChanged(int next, _) {
    setState(() {
      position = next;
    });
  }

  double get _aspectRatio {
    switch (widget.type) {
      case PictureCarouselType.profile:
        return 1;
      case PictureCarouselType.home:
        return 3 / 2;
    }
  }

  CarouselOptions get _options {
    switch (widget.type) {
      case PictureCarouselType.profile:
        return CarouselOptions(
          aspectRatio: _aspectRatio,
          viewportFraction: 1,
          enableInfiniteScroll: false,
          onPageChanged: _onPageChanged,
        );
      case PictureCarouselType.home:
        return CarouselOptions(
          aspectRatio: _aspectRatio,
          viewportFraction: 0.7,
          enableInfiniteScroll: false,
          onPageChanged: _onPageChanged,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
            items: widget.pictures.map((url) {
              return CachedNetworkImage(
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  return AspectRatio(
                    aspectRatio: _aspectRatio,
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                  );
                },
                imageUrl: url,
              );
            }).toList(),
            options: _options),
        const SizedBox(height: 8),
        if (widget.type == PictureCarouselType.profile)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.pictures.length,
              (index) {
                return FaIcon(
                  position == index
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  size: 12,
                );
              },
            ),
          )
      ],
    );
  }
}

enum PictureCarouselType {
  profile,
  home,
}
