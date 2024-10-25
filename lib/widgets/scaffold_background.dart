import 'dart:ui';

import 'package:flutter/material.dart';

class ScaffoldBackground extends StatelessWidget {
  const ScaffoldBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The background container with radial gradient
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.6, 0.3),
              radius: 0.7,
              colors: [
                Color(0xFF415A77), // First color (#415A77)
                Color(0xFF0D1B2A), // Second color (#0D1B2A)
              ],
              stops: [
                0.0,
                1.0
              ], // Defines the stops for the colors in the gradient
            ),
          ),
        ),
        // Applying the blur effect
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Color.fromARGB(1, 38, 2, 2),
          ),
        ),
      ],
    );
  }
}
