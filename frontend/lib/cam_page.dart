import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/chess_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  void _onCameraButtonPressed() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ChessPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Ink(
                decoration: const ShapeDecoration(
                  color: Colors.lightBlue,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                    icon: const Icon(Icons.camera_alt_outlined),
                    color: Colors.white,
                    onPressed: () {
                      _onCameraButtonPressed();
                    }))));
  }
}
