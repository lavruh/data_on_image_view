import 'dart:io';
import 'package:data_on_image_view/domain/view_port.dart';
import 'package:flutter/material.dart';

class OverviewWidget extends StatelessWidget {
  const OverviewWidget(
      {Key? key,
      required this.img,
      required this.viewPorts,
      required this.child})
      : super(key: key);

  final File img;
  final Map<String, ViewPort> viewPorts;
  final Widget Function(ViewPort) child;

  @override
  Widget build(BuildContext context) {
    Widget content= const CircularProgressIndicator();

    if(img.existsSync()) {
      final image = FileImage(img);
      content = Stack(
        alignment: AlignmentDirectional.center,
        children: [Image(image: image), ...viewPorts.values.map(child)],
      );
    }
    return Scaffold(
      body: Center(
        child: content
      ),
    );
  }
}
