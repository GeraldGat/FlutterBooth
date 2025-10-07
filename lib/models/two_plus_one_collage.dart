import 'dart:io';
import 'package:image/image.dart' as img;

import 'package:flutterbooth/models/collage.dart';

class TwoPlusOneCollage extends Collage {
  @override
  int get imageCount => 3;

  @override
  String get thumbnailAsset => 'assets/images/collage_thumbnails/two_plus_one_collage.png';

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
      final image3 = img.decodeImage(File(images[2]).readAsBytesSync())!;

      final rotated2 = img.copyRotate(image2, angle: 90);
      final rotated3 = img.copyRotate(image3, angle: 90);
      
      final cropped1 = img.copyResize(image1, width: collageFinalWidth * 2 ~/ 3, height: collageFinalHeight, maintainAspect: true, backgroundColor: img.ColorInt32.rgb(255, 255, 255));
      final cropped2 = img.copyResize(rotated2, width: collageFinalWidth ~/ 3, height: collageFinalHeight ~/ 2, maintainAspect: true, backgroundColor: img.ColorInt32.rgb(255, 255, 255));
      final cropped3 = img.copyResize(rotated3, width: collageFinalWidth ~/ 3, height: collageFinalHeight ~/ 2, maintainAspect: true, backgroundColor: img.ColorInt32.rgb(255, 255, 255));

      final collage = img.Image(width: collageFinalWidth, height: collageFinalHeight);
      
      img.compositeImage(collage, cropped1, dstX: 0, dstY: 0);
      img.compositeImage(collage, cropped2, dstX: collageFinalWidth ~/ 3, dstY: 0);
      img.compositeImage(collage, cropped3, dstX: collageFinalWidth ~/ 3, dstY: collageFinalHeight ~/ 2);

      File(outputPath).writeAsBytesSync(img.encodeJpg(collage, quality: 100));
    } catch (e) {
      return false;
    }

    return true;
  }
}