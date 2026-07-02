import 'package:flutterbooth/models/collage.dart';

class TwoPlusOneCollage extends Collage {
  @override
  int get imageCount => 3;

  @override
  String get thumbnailAsset => 'assets/images/collage_thumbnails/two_plus_one_collage.png';

  @override
  List<Map<String, int>> get layoutItems => [
    {
      'rotation': 0,
      'targetWidth': (canvasWidth ~/ 3) * 2,
      'targetHeight': canvasHeight,
      'dstX': 0,
      'dstY': 0,
    },
    {
      'rotation': 270,
      'targetWidth': canvasWidth ~/ 3,
      'targetHeight': canvasHeight ~/ 2,
      'dstX': (canvasWidth ~/ 3) * 2,
      'dstY': 0,
    },
    {
      'rotation': 270,
      'targetWidth': canvasWidth ~/ 3,
      'targetHeight': canvasHeight ~/ 2,
      'dstX': (canvasWidth ~/ 3) * 2,
      'dstY': canvasHeight ~/ 2,
    },
  ];
}
