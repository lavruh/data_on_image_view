import 'dart:io';

import 'package:data_on_image_view/domain/overview_screen_config.dart';
import 'package:data_on_image_view/ui/screens/editor_screen.dart';
import 'package:data_on_image_view/ui/widgets/floating_panel_widget.dart';
import 'package:data_on_image_view/ui/widgets/overview_widget.dart';
import 'package:data_on_image_view/ui/widgets/view_port_widget.dart';
import 'package:data_on_image_view/utils/data_processor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({
    super.key,
    required this.config,
    this.data,
    this.useMenu = true,
    this.keyboardShortcuts = false,
    required this.onSaveConfig,
    required this.selectFileDialog,
  });

  final OverviewScreenConfig config;
  final Map<String, Map<String, String>>? data;
  final bool useMenu;
  final bool keyboardShortcuts;
  final Function(OverviewScreenConfig) onSaveConfig;
  final Future<File> Function(String title) selectFileDialog;

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

    return KeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKeyEvent: (key) {
          if (widget.keyboardShortcuts == false) return;
          if (key is KeyDownEvent) {
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
    try {
      final f = await widget.selectFileDialog("Open config file");
      config = OverviewScreenConfig.fromJson(f.readAsStringSync());
      setState(() {});
    } catch (e) {
      _showSnakbar(e, context);
    }
  }

  _openEditor(BuildContext c) async {
    final s =
        await Navigator.of(c).push(MaterialPageRoute<OverviewScreenConfig>(
            builder: (_) => EditorScreen(
                  config: config,
                  saveConfig: (newConfig) {
                    config = newConfig;
                    widget.onSaveConfig(newConfig);
                  },
                  selectImage: () =>
                      widget.selectFileDialog("Select image file"),
                )));
    if (s != null) {
      config = s;
      setState(() {});
    }
  }

  _loadData() async {
    try {
      final f = await widget.selectFileDialog("Select data file");
      data = DataProcessor().getData(f);
      if (data.containsKey('config')) {
        final path = data['config'];
        config = OverviewScreenConfig.fromJson(
            File(path?['config'] ?? '').readAsStringSync());
      }
      setState(() {});
    } catch (e) {
      _showSnakbar(e, context);
    }
  }

  void _createConfig() async {
    try {
      final f = await widget.selectFileDialog('Set new config file name');
      await f.create();
      config = OverviewScreenConfig(path: f.path, viewPorts: {});
      setState(() {});
    } catch (e) {
      _showSnakbar(e, context);
    }
  }

  _showSnakbar(Object e, BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
}
