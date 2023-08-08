import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import 'transducer/diagonal_transducer.dart';
import 'transducer/jigsaw_transducer.dart';

class SplitManager {
  SplitManager({required this.imageBytes});

  final Uint8List imageBytes;

  Future<List<Uint8List>> getSplitImages(int xNum, int yNum) async {
    img.Image image = img.decodeImage(imageBytes)!;

    final int width = (image.width / xNum).floor();
    final int height = (image.height / yNum).floor();
    int x = 0, y = 0;

    final List<img.Image> parts = [];
    for (int i = 0; i < yNum; i++) {
      for (int j = 0; j < xNum; j++) {
        parts.add(img.copyCrop(image, x: x, y: y, width: width, height: height));
        x += width;
      }
      x = 0;
      y += height;
    }

    final List<Uint8List> output = [];
    for (var part in parts) {
      output.add(img.encodePng(part));
    }

    return output;
  }

  DiagonalTransducer coverDiagonal(int xNum, int yNum, Widget widget) =>
      DiagonalTransducer(xNum: xNum, yNum: yNum, child: widget);

  JigsawTransducer coverJigsaw(int xNum, int yNum, Widget widget) =>
      JigsawTransducer(xNum: xNum, yNum: yNum, child: widget);
}
