import 'package:flutter/material.dart';

class ViewPort {
  final String id;
  final double x;
  final double y;
  final String title;
  final Color backgroundColor;
  final Color titleColor;
  final Color textColor;

  const ViewPort({
    required this.id,
    required this.x,
    required this.y,
    required this.title,
    Color? color,
    Color? backgroundColor,
    Color? titleColor,
    Color? textColor,
  })  : backgroundColor = backgroundColor ?? Colors.white70,
        titleColor = titleColor ?? (color ?? Colors.black),
        textColor = textColor ?? (color ?? Colors.black);
}
