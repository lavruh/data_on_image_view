import 'package:data_on_image_view/domain/dataview_on_image_state.dart';
import 'package:data_on_image_view/ui/screens/overview_screen.dart';
import 'package:data_on_image_view/ui/widgets/dataview_on_image_settings_widget.dart';
import 'package:flutter/material.dart';

class DataViewOnImageScreen extends StatefulWidget {
  const DataViewOnImageScreen({super.key, required this.state});
  final DataViewOnImageState state;
  @override
  State<DataViewOnImageScreen> createState() => _DataViewOnImageScreenState();
}

class _DataViewOnImageScreenState extends State<DataViewOnImageScreen> {
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
    final config = state.selectedConfig;
    Widget body = Container();

    if (config != null) {
      body = OverviewScreen(
        key: Key(DateTime.now().toString()),
        config: config,
        data: state.data,
        useMenu: false,
        onSaveConfig: (conf) {
          state.updateConfig(conf);
          state.saveConfigFile();
        },
        selectFileDialog: (title) async => state.selectFile(context, title),
      );
    } else {
      body = Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () => state.selectConfigFile(context),
                child: const Text('Select config file')),
            TextButton(
                onPressed: () => state.createConfigFile(context),
                child: const Text('New blank config')),
            TextButton(
                onPressed: () => state.loadData(context),
                child: const Text('Open data file')),
          ],
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () => state.loadData(context),
                icon: const Icon(Icons.dataset_linked)),
            if (state.configSelected)
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: DataViewOnImageSettingsWidget(state: state),
                          );
                        });
                  },
                  icon: const Icon(Icons.settings))
          ],
        ),
        body: body);
  }
}
