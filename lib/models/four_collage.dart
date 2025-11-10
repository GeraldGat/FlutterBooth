import 'dart:io';
import 'package:image/image.dart' as img;

import 'package:flutterbooth/models/collage.dart';

class FourCollage extends Collage {
  @override
  int get imageCount => 4;

  @override
  String get thumbnailAsset => 'assets/images/collage_thumbnails/four_collage.png';

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
      final image4 = img.decodeImage(File(images[3]).readAsBytesSync())!;
      
      final cropped1 = copyResizeAndCrop(image1, width: collageFinalWidth ~/ 2, height: collageFinalHeight ~/ 2);
      final cropped2 = copyResizeAndCrop(image2, width: collageFinalWidth ~/ 2, height: collageFinalHeight ~/ 2);
      final cropped3 = copyResizeAndCrop(image3, width: collageFinalWidth ~/ 2, height: collageFinalHeight ~/ 2);
      final cropped4 = copyResizeAndCrop(image4, width: collageFinalWidth ~/ 2, height: collageFinalHeight ~/ 2);

      final collage = img.Image(width: collageFinalWidth, height: collageFinalHeight);
      
      img.compositeImage(collage, cropped1, dstX: 0, dstY: 0);
      img.compositeImage(collage, cropped2, dstX: collageFinalWidth ~/ 2, dstY: 0);
      img.compositeImage(collage, cropped3, dstX: 0, dstY: collageFinalHeight ~/ 2);
      img.compositeImage(collage, cropped4, dstX: collageFinalWidth ~/ 2, dstY: collageFinalHeight ~/ 2);

      File(outputPath).writeAsBytesSync(img.encodeJpg(collage, quality: 100));
    } catch (e) {
      return false;
    }

    return true;
  }
}