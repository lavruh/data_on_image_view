import 'dart:convert';
import 'dart:io';

import 'package:data_on_image_view/domain/view_port.dart';

class OverviewScreenConfig {
  final String path;
  final Map<String, ViewPort> viewPorts;

  OverviewScreenConfig({required this.path, required this.viewPorts});

  File get getFile => File(path);

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'viewPorts': viewPorts.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  factory OverviewScreenConfig.fromMap(Map<String, dynamic> map) {
    return OverviewScreenConfig(
      path: map['path'] as String,
      viewPorts: (map['viewPorts'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, ViewPort.fromMap(value))),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory OverviewScreenConfig.fromJson(String s) =>
      OverviewScreenConfig.fromMap(jsonDecode(s));
}
