import 'package:flutter/material.dart';

import '../transducer/base_transducer.dart';
import 'clip_info.dart';
import 'mode_clipper.dart';
import 'mode_painter.dart';

class ClipperWidget extends StatelessWidget {
  const ClipperWidget({super.key, required this.child, required this.baseTransistor});

  final BaseTransducer baseTransistor;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: baseTransistor.clipInfoList
          .map((e) => _preview(e.key, e.sizePathConverter, e.args))
          .toList(),
    );
  }

  Widget _preview(GlobalKey key, ClipConverter converter, Map<String, dynamic> args) => Stack(
        fit: StackFit.expand,
        children: [
          RepaintBoundary(
              key: key,
              child: ClipPath(
                clipper: ModeClipper(sizePathConverter: converter, args: args),
                child: child,
              )),
          CustomPaint(painter: ModePainter(sizePathConverter: converter, args: args)),
        ],
      );
}
