import 'package:flutterbooth/models/collage.dart';

class FourCollage extends Collage {
  @override
  int get imageCount => 4;

  @override
  String get thumbnailAsset => 'assets/images/collage_thumbnails/four_collage.png';

  @override
  List<Map<String, int>> get layoutItems => [
    {
      'rotation': 0,
      'targetWidth': canvasWidth ~/ 2,
      'targetHeight': canvasHeight ~/ 2,
      'dstX': 0,
      'dstY': 0,
    },
    {
      'rotation': 0,
      'targetWidth': canvasWidth ~/ 2,
      'targetHeight': canvasHeight ~/ 2,
      'dstX': canvasWidth ~/ 2,
      'dstY': 0,
    },
    {
      'rotation': 0,
      'targetWidth': canvasWidth ~/ 2,
      'targetHeight': canvasHeight ~/ 2,
      'dstX': 0,
      'dstY': canvasHeight ~/ 2,
    },
    {
      'rotation': 0,
      'targetWidth': canvasWidth ~/ 2,
      'targetHeight': canvasHeight ~/ 2,
      'dstX': canvasWidth ~/ 2,
      'dstY': canvasHeight ~/ 2,
    },
  ];
}
