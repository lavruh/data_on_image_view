import 'dart:io';
import 'package:data_on_image_view/domain/view_port.dart';
import 'package:flutter/material.dart';

class OverviewWidget extends StatelessWidget {
  const OverviewWidget(
      {super.key,
      required this.img,
      required this.viewPorts,
      required this.child});

  final File img;
  final Map<String, ViewPort> viewPorts;
  final Widget Function(ViewPort) child;

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Image file does not exist. Select correct file."),
        ),
        CircularProgressIndicator(),
      ],
    ));

    if (img.existsSync()) {
      final image = FileImage(img);
      content = Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.topStart,
        children: [
          Image(
            image: image,
            alignment: Alignment.topLeft,
          ),
          ...viewPorts.values.map(child)
        ],
      );
    }
    return Scaffold(
      body: content,
    );
  }
}
