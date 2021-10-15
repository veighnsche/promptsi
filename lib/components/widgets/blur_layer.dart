import 'dart:ui';

import 'package:flutter/material.dart';

class BlurLayer extends StatelessWidget {
  const BlurLayer({Key? key, required this.sigma}) : super(key: key);

  final double sigma;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: sigma,
            sigmaY: sigma,
          ),
          child: Container(
            color: Colors.blueGrey.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

}
