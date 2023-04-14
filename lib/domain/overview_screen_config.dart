import 'dart:io';

import 'package:data_on_image_view/domain/view_port.dart';

class OverviewScreenConfig {
  final String path;
  final Map<String, ViewPort> viewPorts;

  OverviewScreenConfig(
      {required this.path,  required this.viewPorts});

  File get getFile => File(path);
}
