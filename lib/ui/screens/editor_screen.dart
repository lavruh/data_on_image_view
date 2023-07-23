import 'dart:io';

import 'package:data_on_image_view/domain/overview_screen_config.dart';
import 'package:data_on_image_view/domain/view_port.dart';
import 'package:data_on_image_view/ui/widgets/editor_dialog_widget.dart';
import 'package:data_on_image_view/ui/widgets/floating_panel_widget.dart';
import 'package:data_on_image_view/ui/widgets/overview_widget.dart';
import 'package:data_on_image_view/ui/widgets/view_port_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen(
      {Key? key, required this.config, this.useBackButton = true})
      : super(key: key);

  final bool useBackButton;
  final OverviewScreenConfig config;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  Map<String, ViewPort> ports = {};
  late File img;
  final GlobalKey _widgetKey = GlobalKey();

  @override
  void initState() {
    ports = widget.config.viewPorts;
    img = widget.config.getFile;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        OverviewWidget(
            key: _widgetKey,
            img: img,
            viewPorts: ports,
            child: (item) => ViewPortWidget(
                  item: item,
                  childWrap: (child) => _getChild(child, item),
                  data: const {'data': 'text'},
                )),
        FloatingPanelWidget(
          children: [
            IconButton(
                onPressed: _addViewPort,
                tooltip: 'Add Viewport',
                icon: const Icon(Icons.add_to_photos)),
            IconButton(
                onPressed: _pickUpImage,
                tooltip: 'Select image',
                icon: const Icon(Icons.image)),
            IconButton(
                onPressed: _saveConfig,
                tooltip: 'Save config to file',
                icon: const Icon(Icons.save)),
            if (widget.useBackButton)
              IconButton(
                  onPressed: _goBack,
                  tooltip: 'Back',
                  icon: const Icon(Icons.arrow_back)),
          ],
        ),
      ]),
    );
  }

  Widget _getChild(Widget child, ViewPort item) {
    final RenderBox box =
        _widgetKey.currentContext?.findRenderObject() as RenderBox;
    return GestureDetector(
      onLongPress: () => _openEditor(item),
      child: Draggable(
        feedback: child,
        child: child,
        onDragEnd: (data) {
          final correctedPoint = box.globalToLocal(data.offset);
          _updateViewPort(item.copyWith(
            x: correctedPoint.dx,
            y: correctedPoint.dy,
          ));
        },
      ),
    );
  }

  _updateViewPort(ViewPort item) {
    ports[item.id] = item;
    setState(() {});
  }

  _openEditor(ViewPort item) async {
    final oldID = item.id;
    final newItem = await showDialog<ViewPort>(
        context: context,
        builder: (_) => EditorDialogWidget(
              item: item,
              onDelete: () => _removeViewPort(item.id),
              onDuplicate: () => _duplicateViewPort(item),
            ));
    if (newItem != null) {
      if (oldID != newItem.id) {
        _removeViewPort(oldID);
      }
      _updateViewPort(newItem);
    }
  }

  _updateImage(String p) {
    img = File(p);
    setState(() {});
  }

  _saveConfig() async {
    final path = await FilePicker.platform.saveFile();
    if (path != null) {
      final file = File(path);
      final contents = widget.config.copyWith(path: img.path, viewPorts: ports);
      file.writeAsStringSync(contents.toJson());
    }
  }

  _addViewPort() {
    _openEditor(const ViewPort(id: '', x: 0, y: 0, title: ''));
  }

  void _pickUpImage() async {
    final filePath = await FilePicker.platform
        .pickFiles(dialogTitle: 'Open image file', type: FileType.image);
    if (filePath != null) {
      if (filePath.paths.isNotEmpty && filePath.paths.first != null) {
        _updateImage(filePath.paths.first!);
      }
    }
  }

  _goBack() {
    final returnData =
        OverviewScreenConfig(path: widget.config.path, viewPorts: ports);
    Navigator.of(context).pop(returnData);
  }

  void _removeViewPort(String oldID) {
    ports.remove(oldID);
  }

  _duplicateViewPort(ViewPort item) {
    final newID = '${item.id}_';
    _updateViewPort(item.copyWith(
      id: newID,
      x: item.x + 50,
      y: item.y + 50,
    ));
  }
}
