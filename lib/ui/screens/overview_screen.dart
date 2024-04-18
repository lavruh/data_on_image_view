import 'dart:io';

import 'package:data_on_image_view/domain/overview_screen_config.dart';
import 'package:data_on_image_view/ui/screens/editor_screen.dart';
import 'package:data_on_image_view/ui/widgets/floating_panel_widget.dart';
import 'package:data_on_image_view/ui/widgets/overview_widget.dart';
import 'package:data_on_image_view/ui/widgets/view_port_widget.dart';
import 'package:data_on_image_view/utils/data_processor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({
    Key? key,
    required this.config,
    this.data,
    this.useMenu = true,
  }) : super(key: key);

  final OverviewScreenConfig config;
  final Map<String, Map<String, String>>? data;
  final bool useMenu;

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
    final buttons = Column(mainAxisSize: MainAxisSize.min, children: [
      TextButton(
          onPressed: _createConfig, child: const Text('New blank config')),
      TextButton(onPressed: _openConfig, child: const Text('Open config file')),
      TextButton(onPressed: _loadData, child: const Text('Open data file')),
    ]);

    final overview = OverviewWidget(
        img: config.getFile,
        viewPorts: config.viewPorts,
        child: (e) {
          return ViewPortWidget(
            item: e,
            data: data[e.id],
          );
        });

    final panel = FloatingPanelWidget(
      initPosition: menuPosition,
      children: [
        IconButton(
            onPressed: () => _openEditor(context),
            tooltip: 'Edit widgets config',
            icon: const Icon(Icons.edit)),
        if (widget.data == null)
          IconButton(
              onPressed: () => _loadData(),
              tooltip: 'Load data file',
              icon: const Icon(Icons.file_open)),
        IconButton(
            onPressed: () => _openConfig(),
            tooltip: 'Load config file',
            icon: const Icon(Icons.settings)),
      ],
    );

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
                if (config.getFile.existsSync() == false) buttons else overview,
                if (menuVisible && widget.useMenu) panel
              ],
            )))));
  }

  _openConfig() async {
    final f = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select config file',
      allowedExtensions: ['json'],
      type: FileType.custom,
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

  _loadData() async {
    final f = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select data file',
      allowedExtensions: ['json', 'csv'],
      type: FileType.custom,
    );
    if (f != null) {
      final path = f.paths.first ?? '';
      data = DataProcessor().getData(File(path));
      if (data.containsKey('config')) {
        final path = data['config'];
        config = OverviewScreenConfig.fromJson(
            File(path?['config'] ?? '').readAsStringSync());
      }
      setState(() {});
    }
  }

  void _createConfig() async {
    final f = await FilePicker.platform.saveFile(
      dialogTitle: 'Set new config file name',
      allowedExtensions: ['json'],
      type: FileType.custom,
    );
    if (f != null) {
      await File(f).create();
      config = OverviewScreenConfig(path: f, viewPorts: {});
      setState(() {});
    }
  }
}
