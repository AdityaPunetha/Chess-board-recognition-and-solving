import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/image_display_page.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? capturedImage;

  Future<void> _onCameraButtonPressed() async {
    final XFile? ximage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    final File? image = File(ximage!.path);
    if (image == null) {
      return;
    }
    setState(() {
      capturedImage = image;
    });
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
