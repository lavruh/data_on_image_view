import 'package:data_on_image_view/domain/view_port.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class EditorPanelWidget extends StatefulWidget {
  const EditorPanelWidget(
      {Key? key,
      required this.openInEditor,
      required this.setImagePath,
      required this.saveConfig})
      : super(key: key);
  final Function(ViewPort) openInEditor;
  final Function(String) setImagePath;
  final Function() saveConfig;

  @override
  State<EditorPanelWidget> createState() => _EditorPanelWidgetState();
}

class _EditorPanelWidgetState extends State<EditorPanelWidget> {
  double x = 0;
  double y = 0;

  @override
  Widget build(BuildContext context) {
    final child = Card(
      color: Colors.white24,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: 5,
              height: 25,
              color: Colors.grey,
            ),
          ),
          IconButton(
              onPressed: _addViewPort, icon: const Icon(Icons.add_to_photos)),
          IconButton(onPressed: _pickUpImage, icon: const Icon(Icons.image)),
          IconButton(
              onPressed: widget.saveConfig, icon: const Icon(Icons.save)),
        ],
      ),
    );

    return Positioned(
      top: y,
      left: x,
      child: Draggable(
        onDragEnd: (details) {
          final pos = details.offset;
          x = pos.dx;
          y = pos.dy;
          setState(() {});
        },
        feedback: child,
        child: child,
      ),
    );
  }

  _addViewPort() {
    widget.openInEditor(const ViewPort(id: '', x: 0, y: 0, title: ''));
  }

  void _pickUpImage() async {
    final filePath = await FilePicker.platform
        .pickFiles(dialogTitle: 'Open image file', type: FileType.image);
    if(filePath != null){
      if(filePath.paths.isNotEmpty && filePath.paths.first != null) {
        widget.setImagePath(filePath.paths.first!);
      }
    }
  }
}
