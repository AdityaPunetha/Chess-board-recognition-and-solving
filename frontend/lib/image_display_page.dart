import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'chess_page.dart';
import 'package:http/http.dart' as http;

class ImageDisplay extends StatefulWidget {
  final File? image;
  const ImageDisplay({Key? key, required this.image}) : super(key: key);
  @override
  _ImageDisplayState createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  var fen = '';

  Future<void> _getPosition(i) async {
    final response = await http.get(Uri.parse(
        'https://chess-recognition-api.herokuapp.com/api/sample_fen'));
    if (response.statusCode == 200) {
      var jsonFen = jsonDecode(response.body);
      fen = jsonFen['fen'];
    } else {
      throw Exception('Failed to load album');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChessPage(fen: fen),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    File? _displayImage = widget.image;

    return Scaffold(
        appBar: AppBar(),
        body: Column(children: [
          _displayImage != null ? Image.file(_displayImage) : Container(),
          Expanded(
              child: Ink(
            decoration: const ShapeDecoration(
              color: Colors.green,
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: const Icon(Icons.check_sharp),
              color: Colors.white,
              onPressed: () {
                _getPosition(_displayImage);
              },
            ),
          ))
        ]));
  }
}
