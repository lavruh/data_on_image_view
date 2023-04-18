import 'dart:io';

import 'package:data_on_image_view/domain/overview_screen_config.dart';
import 'package:data_on_image_view/ui/screens/editor_screen.dart';
import 'package:data_on_image_view/ui/widgets/floating_panel_widget.dart';
import 'package:data_on_image_view/ui/widgets/overview_widget.dart';
import 'package:data_on_image_view/ui/widgets/view_port_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({Key? key, required this.config, this.data})
      : super(key: key);

  final OverviewScreenConfig config;
  final Map<String, Map<String, String>>? data;

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  late OverviewScreenConfig config;
  Map<String, Map<String, String>> data = {};
  bool menuVisible = false;
  Offset menuPosition = const Offset(0, 0);

  @override
  void initState() {
    config = widget.config;
    data = widget.data ?? {};
    super.initState();
  }

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
        child: GestureDetector(
            onTapUp: (d) {
              menuPosition = d.localPosition;
              menuVisible = !menuVisible;
              setState(() {});
            },
            child: Scaffold(
                body: Center(
                    child: Stack(
              children: [
                config.getFile.existsSync() == false
                    ? TextButton(
                        onPressed: _openConfig,
                        child: const Text('Open config file'))
                    : OverviewWidget(
                        img: config.getFile,
                        viewPorts: config.viewPorts,
                        child: (e) {
                          return ViewPortWidget(
                            item: e,
                            data: data[e.id],
                          );
                        }),
                if (menuVisible)
                  FloatingPanelWidget(
                    initPosition: menuPosition,
                    children: [
                      IconButton(
                          onPressed: () => _openEditor(context),
                          icon: const Icon(Icons.edit)),
                      if (widget.data == null)
                        IconButton(
                            onPressed: () => _loadData(),
                            icon: const Icon(Icons.file_open)),
                      IconButton(
                          onPressed: () => _openConfig(),
                          icon: const Icon(Icons.settings)),
                    ],
                  )
              ],
            )))));
  }

  _openConfig() async {
    final f = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select config file',
      allowedExtensions: ['.json'],
    );
    if (f != null) {
      final path = f.paths.first ?? '';
      config = OverviewScreenConfig.fromJson(File(path).readAsStringSync());
      setState(() {});
    }
  }

  _openEditor(BuildContext c) async {
    final s = await Navigator.of(c).push(
        MaterialPageRoute<OverviewScreenConfig>(
            builder: (_) => EditorScreen(config: config)));
    if (s != null) {
      config = s;
      setState(() {});
    }
  }

  _loadData() {}
}
