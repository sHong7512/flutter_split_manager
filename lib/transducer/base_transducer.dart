import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../clip/clip_info.dart';
import '../clip/clipper_widget.dart';

abstract class BaseTransducer {
  BaseTransducer({required this.child}) {
    clipInfoList = setClipInfo();
    widget = ClipperWidget(baseTransistor: this, child: child);
  }

  final Widget child;
  late final ClipperWidget widget;
  late final List<ClipInfo> clipInfoList;

  List<ClipInfo> setClipInfo();

  Future<List<Uint8List>?> getImageList() async {
    final bufList = <Uint8List>[];
    for (final info in clipInfoList) {
      final c = await _capture(info.key);
      if (c == null) {
        print('<CollaboClipper><$hashCode> capture failed!');
        return null;
      }
      bufList.add(c);
    }
    return bufList;
  }

  Future<Uint8List?> _capture(GlobalKey boundaryKey, [bool improve = true]) async {
    try {
      final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      final context = boundaryKey.currentContext;

      if (boundary!.debugNeedsPaint != false || context == null) {
        print("<CollaboClipper> <$hashCode> Waiting for boundary to be painted.");
        await Future.delayed(const Duration(milliseconds: 20));
        return _capture(boundaryKey, improve);
      }

      final width = boundary.size.width;
      final height = boundary.size.height;

      double widthRatio = MediaQuery.of(context).size.width / width;
      double heightRatio = MediaQuery.of(context).size.height / height;
      if (improve) {
        widthRatio = ui.PlatformDispatcher.instance.views.first.physicalSize.width / width;
        heightRatio = ui.PlatformDispatcher.instance.views.first.physicalSize.height / height;
      }
      final pixelRatio = widthRatio < heightRatio ? widthRatio : heightRatio;

      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        return Uint8List.view(byteData.buffer);
      } else {
        throw Exception('byteData is null!');
      }
    } catch (e) {
      print('<CollaboClipper> <$hashCode> $e');
      return null;
    }
  }
}
