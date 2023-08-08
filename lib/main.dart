import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'page/jigsaw_page.dart';
import 'split_manager.dart';
import 'page/diagonal_page.dart';
import 'page/combine_shape_page.dart';
import 'page/rectangle_page.dart';

const homeRoute = '/';
const rectangleRoute = '/rectangle';
const diagonalRoute = '/diagonal';
const jigsawRoute = '/jigsaw';
const combineShapeRoute = '/combineShape';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ByteData assetImageByteData = await rootBundle.load('assets/test_play.jpg');
  final imageBytes = assetImageByteData.buffer.asUint8List();
  final splitManager = SplitManager(imageBytes: imageBytes);

  runApp(
    MaterialApp(
      initialRoute: homeRoute,
      routes: {
        homeRoute: (context) => const _HomePage(title: 'Split Example'),
        rectangleRoute: (context) => RectanglePage(title: rectangleRoute.substring(1), splitManager: splitManager),
        diagonalRoute: (context) => DiagonalPage(title: diagonalRoute.substring(1), splitManager: splitManager),
        jigsawRoute: (context) => JigsawPage(title: jigsawRoute.substring(1), splitManager: splitManager),
        combineShapeRoute: (context) => CombineShapePage(title: combineShapeRoute.substring(1), splitManager: splitManager),
      },
    ),
  );
}

class _HomePage extends StatelessWidget {
  const _HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed(rectangleRoute),
              child: Text(rectangleRoute.substring(1))),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed(diagonalRoute),
              child: Text(diagonalRoute.substring(1))),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed(jigsawRoute),
              child: Text(jigsawRoute.substring(1))),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed(combineShapeRoute),
              child: Text(combineShapeRoute.substring(1))),
        ],
      ),
    );
  }
}
