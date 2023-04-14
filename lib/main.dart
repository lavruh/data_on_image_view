import 'package:data_on_image_view/domain/overview_screen_config.dart';
import 'package:data_on_image_view/domain/view_port.dart';
import 'package:data_on_image_view/ui/screens/editor_screen.dart';
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

  @override
  void initState() {
    final m = OverviewScreenConfig(
      path: '/home/lavruh/Documents/20230307_231523.jpg',
      viewPorts: {
        'A_3': const ViewPort(id: 'A_3', x: 310, y: 370, title: 'A 3'),
        'A_4': const ViewPort(
            id: 'A_4', x: 310, y: 470, title: 'A 4', color: Colors.red),
      },
    ).toMap();
    config = OverviewScreenConfig.fromMap(m);
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
                    builder: (_) => OverviewScreen(
                      config: config,
                      data: const {
                        'A_3': {'Rh': '1235', 'd1': '333'},
                        'A_4': {'Rh': '1235'},
                      },
                    ),
                  ));
                },
                child: const Text('Overview')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
                  final s = await Navigator.of(context)
                      .push(MaterialPageRoute<OverviewScreenConfig>(
                    builder: (_) => EditorScreen(
                      config: config,
                    ),
                  ));
                  if (s != null) {
                    final tmp = s.toJson();
                    print(tmp);
                    config = OverviewScreenConfig.fromJson(tmp);
                  }
                },
                child: const Text('Editor')),
          ),
        ],
      ),
    ));
  }
}
