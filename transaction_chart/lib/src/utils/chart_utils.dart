import 'package:flutter/material.dart';

class ChartUtils {
  static const List<Color> colors = [
    Colors.greenAccent,
    Colors.yellowAccent,
    Colors.blueAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.redAccent,
    Colors.cyanAccent,
    Colors.pinkAccent,
    Colors.limeAccent,
    Colors.indigoAccent,
  ];

  static Color getColor(int index) => colors[index % colors.length];

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }
}
