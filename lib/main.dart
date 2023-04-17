import 'dart:io';

import 'package:data_on_image_view/domain/overview_screen_config.dart';
import 'package:data_on_image_view/ui/screens/editor_screen.dart';
import 'package:data_on_image_view/ui/screens/overview_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Screen(),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  late OverviewScreenConfig config;
  Map<String, Map<String, String>> data = {};

  @override
  void initState() {
    config = OverviewScreenConfig(path: '', viewPorts: {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
                  final f = await FilePicker.platform.pickFiles(
                    dialogTitle: 'Select config file',
                    allowedExtensions: ['.json'],
                  );
                  if (f != null) {
                    final path = f.paths.first ?? '';
                    config = OverviewScreenConfig.fromJson(
                        File(path).readAsStringSync());
                  }
                },
                child: const Text('Open config file')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => OverviewScreen(config: config, data: data),
                  ));
                },
                child: const Text('Overview')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
                  final s = await Navigator.of(context).push(
                      MaterialPageRoute<OverviewScreenConfig>(
                          builder: (_) => EditorScreen(config: config)));
                  if (s != null) {
                    config = s;
                  }
                },
                child: const Text('Editor')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
                  final f = await FilePicker.platform.pickFiles(
                    dialogTitle: 'Select data file',
                    allowedExtensions: ['.json'],
                  );
                  if (f != null) {
                    final path = f.paths.first ?? '';
                  }
                },
                child: const Text('Load data')),
          ),
        ],
      ),
    ));
  }
}
