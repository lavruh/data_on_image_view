import 'package:data_on_image_view/domain/dataview_on_image_state.dart';
import 'package:data_on_image_view/ui/screens/editor_screen.dart';
import 'package:flutter/material.dart';

class DataViewOnImageEditor extends StatefulWidget {
  const DataViewOnImageEditor({super.key, required this.state});

  final DataViewOnImageState state;

  @override
  State<DataViewOnImageEditor> createState() => _DataViewOnImageEditorState();
}

class _DataViewOnImageEditorState extends State<DataViewOnImageEditor> {
  @override
  void initState() {
    widget.state.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.state.selectedConfig;

    Widget child = const CircularProgressIndicator();
    if (config != null) {
      try {
        child = EditorScreen(
          config: config,
          useBackButton: false,
          saveConfig: (newConfig) {
            widget.state.updateConfig(newConfig);
            widget.state.saveConfigFile();
          },
          selectImage: () async {
            return await widget.state.selectFile(context, 'Select image');
          },
        );
      } catch (e) {
        child = Text(e.toString());
      }
    }

    return NavigatorPopHandler(
        onPop: () async => widget.state.reloadConfigFile(),
        child: Scaffold(
          appBar: AppBar(
            actions: [],
          ),
          body: child,
        ));
  }
}
