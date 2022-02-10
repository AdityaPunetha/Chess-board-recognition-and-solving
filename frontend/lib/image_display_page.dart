import 'dart:io';

import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final File? image;
  const ImageDisplay({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: const Text('ImageDisplay'));
  }
}
