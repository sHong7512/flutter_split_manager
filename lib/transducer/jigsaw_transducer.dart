import 'dart:math';

import 'package:flutter/material.dart';
import 'package:split_manager/transducer/jigsaw/jigsaw_path_ext.dart';

import '../clip/clip_info.dart';
import 'base_transducer.dart';
import 'jigsaw/jigsaw_info.dart';
import 'jigsaw/jigsaw_line.dart';

class JigsawTransducer extends BaseTransducer {
  JigsawTransducer({
    required Widget child,
    required this.xNum,
    required this.yNum,
  }) : super(child: child);

  final int xNum;
  final int yNum;

  @override
  List<ClipInfo> setClipInfo() {
    final bufList = <ClipInfo>[];
    final xLineMap = <int, Map<int, Map<int, JigsawLine>>>{};
    for (int i = 0; i <= yNum; i++) {
      xLineMap[i] = {};
      for (int j = 0; j < xNum; j++) {
        xLineMap[i]![j] = {};
      }
    }

    for (int i = 0; i < yNum; i++) {
      final yLineMap = <int, JigsawLine>{
        0: JigsawLine(radius: 0, pattern: true),
      };
      for (int j = 0; j < xNum; j++) {
        if (i == 0) {
          xLineMap[i]![j]![0] = JigsawLine(radius: randRadius, pattern: Random().nextBool());
          xLineMap[i]![j]![1] = JigsawLine(radius: randRadius, pattern: Random().nextBool());
          xLineMap[i + 1]![j]![0] = xLineMap[i]![j]![1]!;
        } else {
          xLineMap[i]![j]![1] = JigsawLine(radius: randRadius, pattern: Random().nextBool());
          xLineMap[i + 1]![j]![0] = xLineMap[i]![j]![1]!;
        }

        if (!yLineMap.containsKey(j + 1)) {
          final random = Random().nextBool();
          yLineMap[j + 1] = JigsawLine(radius: randRadius, pattern: random);
        }

        bufList.add(ClipInfo(
          key: GlobalKey(),
          sizePathConverter: lineConverter,
          args: {
            'index': j,
            'moveCnt': i,
            'radiusList': [
              xLineMap[i]![j]![0]!.radius,
              yLineMap[j + 1]!.radius,
              xLineMap[i]![j]![1]!.radius,
              yLineMap[j]!.radius,
            ],
            'patternList': [
              xLineMap[i]![j]![0]!.pattern,
              yLineMap[j + 1]!.pattern,
              xLineMap[i]![j]![1]!.pattern,
              yLineMap[j]!.pattern,
            ],
          },
        ));
      }
    }

    return bufList;
  }

  double get randRadius {
    int min = 6;
    int max = 10;
    return (min + Random().nextInt(max - min)).toDouble();
  }

  Path lineConverter(Size size, Map<String, dynamic> args) {
    final index = args['index'] as int;
    final moveCnt = args['moveCnt'] as int;
    final radiusList = args['radiusList'] as List<double>;
    final patternList = args['patternList'] as List<bool>;
    final double moveX = size.width / xNum;
    final double moveY = size.height / yNum;
    final double baseX = index * size.width / xNum;
    final double baseY = moveCnt * size.height / yNum;

    Path path = Path();
    path.moveTo(baseX, baseY);

    path.xJigsawTo(JigsawInfo(
      start: Offset(baseX, baseY),
      end: Offset(baseX + moveX, baseY),
      maxSize: size,
      radius: min(moveY * 0.4, radiusList[0] * moveX * 0.025),
      pattern: patternList[0],
    ));

    path.yJigsawTo(JigsawInfo(
      start: Offset(baseX + moveX, baseY),
      end: Offset(baseX + moveX, baseY + moveY),
      maxSize: size,
      radius: min(moveX * 0.4, radiusList[1] * moveY * 0.025),
      pattern: patternList[1],
    ));

    path.xJigsawTo(JigsawInfo(
      start: Offset(baseX + moveX, baseY + moveY),
      end: Offset(baseX, baseY + moveY),
      maxSize: size,
      radius: min(moveY * 0.4, radiusList[2] * moveX * 0.025),
      pattern: patternList[2],
    ));

    path.yJigsawTo(JigsawInfo(
      start: Offset(baseX, baseY + moveY),
      end: Offset(baseX, baseY),
      maxSize: size,
      radius: min(moveX * 0.4,radiusList[3] * moveY * 0.025),
      pattern: patternList[3],
    ));

    path.close();
    return path;
  }
}
