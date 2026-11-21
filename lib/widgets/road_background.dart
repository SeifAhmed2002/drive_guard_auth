import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Full-screen road image with a dark gradient on top so text stays readable.
/// Put the image at assets/images/road_bg.png and list it in pubspec.yaml.
class RoadBackground extends StatelessWidget {
  final Widget child;
  const RoadBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/road_bg.png', fit: BoxFit.cover),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x00000000), Color(0x660A0A0A), Color(0xB30A0A0A)],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
        child,
      ],
    );
  }
}