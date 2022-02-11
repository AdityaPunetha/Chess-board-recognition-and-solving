import 'dart:io';
import 'package:flutter/material.dart';
import 'chess_page.dart';

class ImageDisplay extends StatefulWidget {
  final File? image;
  const ImageDisplay({Key? key, required this.image}) : super(key: key);
  @override
  _ImageDisplayState createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  late String fen;

  void _getPosition(i) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChessPage(fen: 'res'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    File? _displayImage = widget.image;

    return Scaffold(
        body: Column(children: [
      _displayImage != null ? Image.file(_displayImage) : Container(),
      Center(
          child: ElevatedButton(
              child: const Text('data'),
              onPressed: () {
                _getPosition(_displayImage);
              }))
    ]));
  }
}
