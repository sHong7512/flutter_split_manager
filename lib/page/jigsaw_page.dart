import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:split_manager/transducer/jigsaw_transducer.dart';

import '../split_manager.dart';

class JigsawPage extends StatelessWidget {
  JigsawPage({
    Key? key,
    required this.title,
    required this.splitManager,
  }) : super(key: key);

  final String title;
  final SplitManager splitManager;
  final int xNum = 6;
  final int yNum = 5;
  final selectedImages = ValueNotifier<List<Uint8List>>([]);

  @override
  Widget build(BuildContext context) {
    final JigsawTransducer jigsaw = splitManager.coverJigsaw(xNum, yNum, Image.memory(splitManager.imageBytes, fit: BoxFit.fill));

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
            child: GestureDetector(
              onTap: () async {
                selectedImages.value = await jigsaw.getImageList() ?? [];
              },
              child: jigsaw.widget,
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<Uint8List>>(
              valueListenable: selectedImages,
              builder: (context, images, child) {
                if (images.isEmpty) return const SizedBox();
                return SingleChildScrollView(
                  child: Wrap(
                    children: images
                        .map((e) => Container(
                              width: MediaQuery.of(context).size.width / xNum,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.lightGreenAccent, width: 2),
                              ),
                              child: Image.memory(e),
                            ))
                        .toList(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
