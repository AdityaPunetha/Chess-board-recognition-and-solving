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
  File? _displayImage;
  late String fen;

  void _nextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChessPage(fen: 'res'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ElevatedButton(
                child: const Text('data'),
                onPressed: () {
                  _nextPage();
                })));
  }
}
