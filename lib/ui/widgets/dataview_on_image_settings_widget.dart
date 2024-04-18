import 'package:data_on_image_view/domain/dataview_on_image_state.dart';
import 'package:data_on_image_view/ui/widgets/editor_widget.dart';
import 'package:flutter/material.dart';

class DataViewOnImageSettingsWidget extends StatefulWidget {
  const DataViewOnImageSettingsWidget({Key? key, required this.state})
      : super(key: key);
  final DataViewOnImageState state;
  @override
  State<DataViewOnImageSettingsWidget> createState() =>
      _DataViewOnImageSettingsWidgetState();
}

class _DataViewOnImageSettingsWidgetState
    extends State<DataViewOnImageSettingsWidget> {
  late final DataViewOnImageState state;

  _reload() => setState(() {});

  @override
  void initState() {
    state = widget.state;
    state.addListener(_reload);
    super.initState();
  }

  @override
  void dispose() {
    state.removeListener(_reload);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = Column(
      children: [
        ListTile(
          leading: const Text('Config file:'),
          title: TextButton(
            onPressed: () => _selectConfigFile(state),
            child: Text(state.selectedConfigPath),
          ),
          trailing: IconButton(
              onPressed: () => state.showConfigEditor(context),
              icon: const Icon(Icons.edit)),
        ),
        ListTile(
          leading: const Text('View port to show:'),
          title: Wrap(
            spacing: 3,
            runSpacing: 3,
            children: state
                .getRelatedViewPortIds()
                .entries
                .map((e) => InputChip(
                      label: Text(e.key),
                      selected: e.value,
                      onPressed: () => state.toggleViewPortActivation(e.key),
                    ))
                .toList(),
          ),
        ),
      ],
    );
    return EditorWidget(
        isSet: state.configSelected,
        isChanged: state.configChanged,
        save: state.updateConfig,
        child: child);
  }

  void _selectConfigFile(DataViewOnImageState state) {
    state.selectConfigFile();
  }
}
