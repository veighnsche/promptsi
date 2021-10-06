import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prompts_game/components/widgets/app_future_builder.dart';

class PictureCarousel extends StatefulWidget {
  const PictureCarousel({
    Key? key,
    required this.picturesAsync,
    required this.type,
  }) : super(key: key);

  const PictureCarousel.profile({
    Key? key,
    required this.picturesAsync,
    this.type = PictureCarouselType.onProfile,
  }) : super(key: key);

  const PictureCarousel.home({
    Key? key,
    required this.picturesAsync,
    this.type = PictureCarouselType.onFeed,
  }) : super(key: key);

  final Future<List<String>> picturesAsync;
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
      case PictureCarouselType.onProfile:
        return 1;
      case PictureCarouselType.onFeed:
        return 3 / 2;
    }
  }

  CarouselOptions get _options {
    switch (widget.type) {
      case PictureCarouselType.onProfile:
        return CarouselOptions(
          aspectRatio: _aspectRatio,
          viewportFraction: 1,
          enableInfiniteScroll: false,
          onPageChanged: _onPageChanged,
        );
      case PictureCarouselType.onFeed:
        return CarouselOptions(
          aspectRatio: _aspectRatio,
          viewportFraction: 0.7,
          enableInfiniteScroll: false,
          onPageChanged: _onPageChanged,
        );
    }
  }

  Widget _wrapper({required Widget child}) {
    switch (widget.type) {
      case PictureCarouselType.onProfile:
        final double width = MediaQuery.of(context).size.width;
        return SizedBox(
          width: width,
          height: width + 20,
          child: child,
        );
      case PictureCarouselType.onFeed:
        return AspectRatio(
          aspectRatio: _aspectRatio,
          child: child,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _wrapper(
      child: AppFutureBuilder(
        future: widget.picturesAsync,
        builder: (context, List<String> pictures) {
          return Column(
            children: [
              CarouselSlider(
                items: pictures.map((url) {
                  return CachedNetworkImage(imageUrl: url);
                }).toList(),
                options: _options,
              ),
              if (widget.type == PictureCarouselType.onProfile) ...[
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
            ],
          );
        },
      ),
    );
  }
}

enum PictureCarouselType {
  onProfile,
  onFeed,
}
