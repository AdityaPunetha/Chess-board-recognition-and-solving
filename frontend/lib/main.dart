import 'package:flutter/material.dart';
import 'package:frontend/cam_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const CameraPage(),
    );
  }
}
