import 'package:data_on_image_view/domain/overview_screen_config.dart';
import 'package:data_on_image_view/ui/widgets/overview_widget.dart';
import 'package:data_on_image_view/ui/widgets/view_port_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({Key? key, required this.config, required this.data})
      : super(key: key);

  final OverviewScreenConfig config;
  final Map<String, Map<String, String>> data;

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (key) {
        if (key is RawKeyDownEvent) {
          if (key.physicalKey == PhysicalKeyboardKey.escape) {
            Navigator.of(context).pop();
          }
        }
      },
      child: OverviewWidget(
          img: widget.config.getFile,
          viewPorts: widget.config.viewPorts,
          child: (e) {
            return ViewPortWidget(
              item: e,
              data: widget.data[e.id],
            );
          }),
    );
  }
}
