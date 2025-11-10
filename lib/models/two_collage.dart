import 'dart:io';
import 'package:image/image.dart' as img;

import 'package:flutterbooth/models/collage.dart';

class TwoCollage extends Collage {
  @override
  int get imageCount => 2;

  @override
  String get thumbnailAsset => 'assets/images/collage_thumbnails/two_collage.png';

  @override
  bool buildCollage(List<String> images, String outputPath) {
    if (images.length != imageCount) {
      return false;
    }

    try {
      const collageFinalWidth = 3000;
      const collageFinalHeight = 2000;

      final image1 = img.decodeImage(File(images[0]).readAsBytesSync())!;
      final image2 = img.decodeImage(File(images[1]).readAsBytesSync())!;

      final rotated1 = img.copyRotate(image1, angle: 270);
      final rotated2 = img.copyRotate(image2, angle: 270);
      
      final cropped1 = copyResizeAndCrop(rotated1, width: collageFinalWidth ~/ 2, height: collageFinalHeight);
      final cropped2 = copyResizeAndCrop(rotated2, width: collageFinalWidth ~/ 2, height: collageFinalHeight);

      final collage = img.Image(width: collageFinalWidth, height: collageFinalHeight);
      
      img.compositeImage(collage, cropped1, dstX: 0, dstY: 0);
      img.compositeImage(collage, cropped2, dstX: collageFinalWidth ~/ 2, dstY: 0);

      File(outputPath).writeAsBytesSync(img.encodeJpg(collage, quality: 100));
    } catch (e) {
      return false;
    }

    return true;
  }
}