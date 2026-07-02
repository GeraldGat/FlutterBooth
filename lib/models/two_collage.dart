import 'package:flutterbooth/models/collage.dart';

class TwoCollage extends Collage {
  @override
  int get imageCount => 2;

  @override
  String get thumbnailAsset => 'assets/images/collage_thumbnails/two_collage.png';

  @override
  List<Map<String, int>> get layoutItems => [
    {
      'rotation': 270,
      'targetWidth': canvasWidth ~/ 2,
      'targetHeight': canvasHeight,
      'dstX': 0,
      'dstY': 0,
    },
    {
      'rotation': 270,
      'targetWidth': canvasWidth ~/ 2,
      'targetHeight': canvasHeight,
      'dstX': canvasWidth ~/ 2,
      'dstY': 0,
    },
  ];
}
