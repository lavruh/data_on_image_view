import 'package:data_on_image_view/domain/overview_screen_config.dart';
import 'package:data_on_image_view/ui/screens/overview_screen.dart';
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
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => OverviewScreen(config: config),
                  ));
                },
                child: const Text('Overview')),
          ),
        ],
      ),
    ));
  }
}
