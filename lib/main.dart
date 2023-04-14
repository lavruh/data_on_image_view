import 'package:data_on_image_view/domain/overview_screen_config.dart';
import 'package:data_on_image_view/domain/view_port.dart';
import 'package:data_on_image_view/ui/screens/overview_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = OverviewScreenConfig(
      path: '/home/lavruh/Documents/20230307_231523.jpg',
      viewPorts: {
        'A_3': const ViewPort(
            id: 'A_3', x: 310, y: 370, title: 'A 3'),
        'A_4': const ViewPort(
            id: 'A_4', x: 310, y: 470, title: 'A 4', color: Colors.red),
      },
    );

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OverviewScreen(
        config: config,
        data: const {
          'A_3': {'Rh': '1235', 'd1': '333'},
          'A_4': {'Rh': '1235'},
        },
      ),
    );
  }
}
