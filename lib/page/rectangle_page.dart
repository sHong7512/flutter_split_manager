import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../split_manager.dart';

class RectanglePage extends StatelessWidget {
  RectanglePage({Key? key, required this.title, required this.splitManager}) : super(key: key);

  final String title;
  final SplitManager splitManager;
  final int xNum = 2;
  final int yNum = 3;

  final selectedImage = ValueNotifier<Uint8List?>(null);

  Future<List<Uint8List>> get _splitImages async => await splitManager.getSplitImages(xNum, yNum);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: Image.memory(splitManager.imageBytes, fit: BoxFit.fill),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: FutureBuilder<List<Uint8List>>(
              future: _splitImages,
              builder: (context, snapshot) => snapshot.data == null
                  ? const SizedBox()
                  : Wrap(
                      children: snapshot.data!
                          .map((e) => Container(
                                width: MediaQuery.of(context).size.width / xNum,
                                height: MediaQuery.of(context).size.height / yNum / 3,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.lightGreenAccent, width: 2),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    selectedImage.value = e;
                                  },
                                  child: Image.memory(e, fit: BoxFit.fill),
                                ),
                              ))
                          .toList(),
                    ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<Uint8List?>(
              valueListenable: selectedImage,
              builder: (context, image, child) => image == null
                  ? const SizedBox()
                  : Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightGreenAccent, width: 2)),
                      child: Image.memory(image)),
            ),
          )
        ],
      ),
    );
  }
}
