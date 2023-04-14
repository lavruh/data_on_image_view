import 'package:data_on_image_view/domain/overview_screen_config.dart';
import 'package:data_on_image_view/domain/view_port.dart';
import 'package:data_on_image_view/ui/widgets/editor_dialog_widget.dart';
import 'package:data_on_image_view/ui/widgets/overview_widget.dart';
import 'package:data_on_image_view/ui/widgets/view_port_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key, required this.config}) : super(key: key);

  final OverviewScreenConfig config;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  Map<String, ViewPort> ports = {};

  @override
  void initState() {
    ports = widget.config.viewPorts;
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
            Navigator.of(context).pop(OverviewScreenConfig(
                path: widget.config.path, viewPorts: ports));
          }
        }
      },
      child: Scaffold(
        body: OverviewWidget(
            img: widget.config.getFile,
            viewPorts: ports,
            child: (item) => ViewPortWidget(
                  item: item,
                  childWrap: (child) => _getChild(child, item),
                )),
        floatingActionButton: FloatingActionButton(
          onPressed: _addViewPort,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _getChild(Widget child, ViewPort item) {
    return GestureDetector(
      onLongPress: () => _openEditor(item),
      child: Draggable(
        feedback: child,
        child: child,
        onDragEnd: (data) {
          _updateViewPort(item.copyWith(
            x: data.offset.dx,
            y: data.offset.dy - 20,
          ));
        },
      ),
    );
  }

  _updateViewPort(ViewPort item) {
    ports[item.id] = item;
    setState(() {});
  }

  _addViewPort() {
    _openEditor(const ViewPort(id: '', x: 0, y: 0, title: ''));
  }

  _openEditor(ViewPort item) async {
    final newItem = await showDialog<ViewPort>(
        context: context, builder: (_) => EditorDialogWidget(item: item));
    if (newItem != null) {
      _updateViewPort(newItem);
    }
  }
}
