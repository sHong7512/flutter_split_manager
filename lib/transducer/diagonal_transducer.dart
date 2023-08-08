import 'dart:math';

import 'package:flutter/material.dart';

import 'base_transducer.dart';
import '../clip/clip_info.dart';

class DiagonalTransducer extends BaseTransducer {
  DiagonalTransducer({
    required this.xNum,
    required this.yNum,
    required Widget child,
  }) : super(child: child);

  final int xNum;
  final int yNum;

  @override
  List<ClipInfo> setClipInfo() {
    final bufList = <ClipInfo>[];
    // X stand
    for (int i = 0; i <yNum; i++) {
      for (int j = 0; j <= xNum; j++) {
        bufList.add(ClipInfo(
          key: GlobalKey(),
          sizePathConverter: standConverter,
          args: {'index': j, 'moveCnt': i, 'isXStand': true},
        ));
      }
    }
    // Y stand
    for (int i = 0; i < xNum; i++) {
      for (int j = 0; j <= yNum; j++) {
        bufList.add(ClipInfo(
          key: GlobalKey(),
          sizePathConverter: standConverter,
          args: {'index': j, 'moveCnt': i, 'isXStand': false},
        ));
      }
    }
    return bufList;
  }

  Path standConverter(Size size, Map<String, dynamic> args) {
    final index = args['index'] as int;
    final moveCnt = args['moveCnt'] as int;
    final isXStand = args['isXStand'] as bool;
    final double moveX = size.width / (xNum * 2);
    final double moveY = size.height / (yNum * 2);
    final double baseX = isXStand ? index * size.width / xNum : moveCnt * size.width / xNum + moveX;
    final double baseY = isXStand ? moveCnt * size.height / yNum + moveY : index * size.height / yNum;

    final path = Path();
    path.moveTo(baseX, max(0, baseY - moveY));

    path.lineTo(min(size.width, baseX + moveX), baseY);
    path.lineTo(baseX, min(size.height, baseY + moveY));
    path.lineTo(max(0, baseX - moveX), baseY);
    path.lineTo(baseX, max(0, baseY - moveY));
    return path;
  }
}
