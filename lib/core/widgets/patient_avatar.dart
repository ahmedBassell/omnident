import 'dart:math';

import 'package:flutter/material.dart';

class PatientAvatar extends StatelessWidget {
  final String displayName;
  final double? radius;
  PatientAvatar({required this.displayName, this.radius});

  @override
  Widget build(BuildContext context) {
    List<String> names = displayName.split(' ');
    final String initials = names.map((e) => e[0]).join();
    final Color randomColor =
        Colors.primaries[Random().nextInt(Colors.primaries.length)].shade100;

    return CircleAvatar(
      radius: radius ?? 20,
      backgroundColor: randomColor,
      foregroundColor: getContrastingTextColor(randomColor),
      child: Text(
        initials,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color getContrastingTextColor(Color color) {
    // Calculate the contrast ratio for both black and white
    double luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    double blackContrast = (luminance + 0.05) / (0.0 + 0.05);
    double whiteContrast = (1.0 + 0.05) / (luminance + 0.05);

    // Determine which color (black or white) provides better contrast
    if ((max(blackContrast, whiteContrast) - 1.0).abs() < 0.01) {
      // If the contrast ratios are almost equal, return black by default
      return Colors.black;
    } else {
      return (blackContrast > whiteContrast) ? Colors.black : Colors.white;
    }
  }
}
