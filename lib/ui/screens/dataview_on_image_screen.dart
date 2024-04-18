import 'package:data_on_image_view/domain/dataview_on_image_state.dart';
import 'package:data_on_image_view/ui/screens/overview_screen.dart';
import 'package:data_on_image_view/ui/widgets/dataview_on_image_settings_widget.dart';
import 'package:flutter/material.dart';

class DataViewOnImageScreen extends StatefulWidget {
  const DataViewOnImageScreen({Key? key, required this.state})
      : super(key: key);
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
        config: config,
        data: state.data,
        useMenu: false,
      );
    } else {
      body = Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () => state.createConfigFile(),
                child: const Text('New blank config')),
            TextButton(
                onPressed: () => state.loadData(),
                child: const Text('Open data file')),
          ],
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          actions: [
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
