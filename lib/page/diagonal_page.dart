import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../split_manager.dart';
import '../transducer/diagonal_transducer.dart';

class DiagonalPage extends StatelessWidget {
  DiagonalPage({
    Key? key,
    required this.title,
    required this.splitManager,
  }) : super(key: key);

  final String title;
  final SplitManager splitManager;
  final int xNum = 2;
  final int yNum = 3;
  final selectedImages = ValueNotifier<List<Uint8List>>([]);

  @override
  Widget build(BuildContext context) {
    final DiagonalTransducer diagonal = splitManager.coverDiagonal(
      xNum,
      yNum,
      Image.memory(splitManager.imageBytes, fit: BoxFit.fill),
    );

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
                selectedImages.value = await diagonal.getImageList() ?? [];
              },
              child: diagonal.widget,
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
                              width: MediaQuery.of(context).size.width / (xNum + 1),
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
