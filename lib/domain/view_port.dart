import 'package:flutter/material.dart';

class ViewPort {
  final String id;
  final double x;
  final double y;
  final String title;
  final Color backgroundColor;
  final Color titleColor;
  final Color textColor;
  final double textSize;
  final double titleSize;

  const ViewPort({
    required this.id,
    required this.x,
    required this.y,
    required this.title,
    Color? color,
    Color? backgroundColor,
    Color? titleColor,
    Color? textColor,
    double? titleSize,
    double? textSize,
  })  : backgroundColor = backgroundColor ?? Colors.white70,
        titleColor = titleColor ?? (color ?? Colors.black),
        textColor = textColor ?? (color ?? Colors.black),
        titleSize = titleSize ?? 18,
        textSize = textSize ?? 12;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'x': x,
      'y': y,
      'title': title,
      'backgroundColor': backgroundColor.value,
      'titleColor': titleColor.value,
      'textColor': textColor.value,
      'titleSize' : titleSize,
      'textSize' : textSize,
    };
  }

  factory ViewPort.fromMap(Map<String, dynamic> map) {
    return ViewPort(
      id: map['id'] as String,
      x: map['x'] as double,
      y: map['y'] as double,
      title: map['title'] as String,
      backgroundColor: Color(map['backgroundColor'] ?? Colors.white70),
      titleColor: Color(map['titleColor'] ?? Colors.black),
      textColor: Color(map['textColor'] ?? Colors.black),
      titleSize: map['titleSize'],
      textSize: map['textSize'],
    );
  }

  ViewPort copyWith({
    String? id,
    double? x,
    double? y,
    String? title,
    Color? backgroundColor,
    Color? titleColor,
    Color? textColor,
    double? titleSize,
    double? textSize,
  }) {
    return ViewPort(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      title: title ?? this.title,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleColor: titleColor ?? this.titleColor,
      textColor: textColor ?? this.textColor,
      titleSize: titleSize ?? this.titleSize,
      textSize: textSize ?? this.textSize,
    );
  }
}
