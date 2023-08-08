import 'package:flutter/material.dart';

import 'clip_info.dart';

class ModePainter extends CustomPainter {
  ModePainter({required this.sizePathConverter, required this.args});

  static const painterLineWidth = 3.0;

  final ClipConverter sizePathConverter;
  final Map<String, dynamic> args;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = sizePathConverter(size, args);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.lightGreenAccent
      ..strokeWidth = painterLineWidth;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
