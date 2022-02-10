import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/chess_page.dart';
import 'package:frontend/image_display_page.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? capturedImage;
  Future<void> _pickImage() async {
    final File image =
        (await ImagePicker().pickImage(source: ImageSource.camera)) as File;
    if (image == null) {
      return;
    }
    setState(() {
      capturedImage = image;
    });
  }

  void _onCameraButtonPressed() {
    _pickImage();
    if (capturedImage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageDisplay(
            image: capturedImage,
          ),
        ),
      );
    }
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => const ChessPage()));
  }

  void _click() {
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
                      // _onCameraButtonPressed();
                      _click();
                    }))));
  }
}
