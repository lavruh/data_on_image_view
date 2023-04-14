import 'package:data_on_image_view/domain/overview_screen_config.dart';
import 'package:data_on_image_view/ui/widgets/view_port_widget.dart';
import 'package:flutter/material.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({
    Key? key,
    required this.config,
    required this.data
  }) : super(key: key);

  final OverviewScreenConfig config;
  final Map<String, Map<String, String>> data;

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  @override
  Widget build(BuildContext context) {
    final image = FileImage(widget.config.getFile);
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Image(image: image),
            ...widget.config.viewPorts.values.map((e) {
              return ViewPortWidget(
                item: e,
                data: widget.data[e.id],
              );
            })
          ],
        ),
      ),
    );
  }
}
