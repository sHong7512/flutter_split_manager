import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../split_manager.dart';
import '../transducer/base_transducer.dart';

class CombineShapePage extends StatelessWidget {
  CombineShapePage({
    Key? key,
    required this.title,
    required this.splitManager,
  }) : super(key: key);

  final String title;
  final SplitManager splitManager;
  final int xNum = 3;
  final int yNum = 3;
  final selectedImages = ValueNotifier<List<Uint8List>>([]);

  Future<List<BaseTransducer>> get _xShapesTransistors async {
    final images = await splitManager.getSplitImages(xNum, yNum);
    return images
        .map((e) => splitManager.coverDiagonal(1, 1, Image.memory(e, fit: BoxFit.fill)))
        .toList();
  }

  Future<List<BaseTransducer>> get _jigsawShapesTransistors async {
    final images = await splitManager.getSplitImages(xNum, yNum);
    return images
        .map((e) => splitManager.coverJigsaw(2, 2, Image.memory(e, fit: BoxFit.fill)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: Image.memory(splitManager.imageBytes, fit: BoxFit.fill),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: FutureBuilder<List<BaseTransducer>>(
              future: _xShapesTransistors,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const SizedBox();
                } else {
                  return Wrap(
                    children: snapshot.data!
                        .map((e) => SizedBox(
                              width: MediaQuery.of(context).size.width / xNum,
                              height: MediaQuery.of(context).size.height / yNum / 4,
                              child: GestureDetector(
                                onTap: () async {
                                  selectedImages.value = await e.getImageList() ?? [];
                                },
                                child: e.widget,
                              ),
                            ))
                        .toList(),
                  );
                }
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: FutureBuilder<List<BaseTransducer>>(
              future: _jigsawShapesTransistors,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const SizedBox();
                } else {
                  return Wrap(
                    children: snapshot.data!
                        .map((e) => SizedBox(
                              width: MediaQuery.of(context).size.width / xNum,
                              height: MediaQuery.of(context).size.height / yNum / 4,
                              child: GestureDetector(
                                onTap: () async {
                                  selectedImages.value = await e.getImageList() ?? [];
                                },
                                child: e.widget,
                              ),
                            ))
                        .toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
