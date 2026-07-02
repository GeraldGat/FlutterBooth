import 'dart:io';
import 'dart:isolate';
import 'package:image/image.dart' as img;
import 'package:flutterbooth/exceptions/collage_exception.dart';

abstract class Collage {
  int get imageCount;
  String get thumbnailAsset;
  List<Map<String, int>> get layoutItems;
  int get canvasWidth => 3000;
  int get canvasHeight => 2000;
}

img.Image copyResizeAndCrop(
  img.Image src, {
    int width = 0,
    int height = 0,
}) {
  if (width <= 0 || height <= 0) {
    throw ArgumentError('Width and height must be greater than zero.');
  }

  final srcRatio = src.width / src.height;
  final targetRatio = width / height;

  int resizeWidth, resizeHeight;

  if (srcRatio > targetRatio) {
    resizeWidth = (height * srcRatio).ceil();
    resizeHeight = height;
  } else {
    resizeWidth = width;
    resizeHeight = (width / srcRatio).ceil();
  }

  final resized = img.copyResize(src, width: resizeWidth, height: resizeHeight, maintainAspect: true);

  final xOffset = (resizeWidth - width) ~/ 2;
  final yOffset = (resizeHeight - height) ~/ 2;

  return img.copyCrop(resized, x: xOffset, y: yOffset, width: width, height: height);
}

Future<String> buildCollageInIsolate({
  required int canvasWidth,
  required int canvasHeight,
  required List<Map<String, int>> layout,
  required List<String> imagePaths,
  required String outputPath,
}) async {
  if (imagePaths.length != layout.length) {
    throw CollageException(
      "Invalid number of images for collage",
      details: "Expected ${layout.length} but got ${imagePaths.length}",
    );
  }

  return Isolate.run(() {
    final images = <img.Image>[];
    for (int i = 0; i < imagePaths.length; i++) {
      final fileBytes = File(imagePaths[i]).readAsBytesSync();
      var decoded = img.decodeImage(fileBytes);
      if (decoded == null) {
        throw CollageException("Failed to decode image $i");
      }

      final item = layout[i];
      final rotation = item['rotation'] ?? 0;
      if (rotation != 0) {
        decoded = img.copyRotate(decoded, angle: rotation);
      }

      final cropped = copyResizeAndCrop(
        decoded,
        width: item['targetWidth'] ?? 0,
        height: item['targetHeight'] ?? 0,
      );
      images.add(cropped);
    }

    final collage = img.Image(width: canvasWidth, height: canvasHeight);
    for (int i = 0; i < images.length; i++) {
      final item = layout[i];
      img.compositeImage(
        collage,
        images[i],
        dstX: item['dstX'] ?? 0,
        dstY: item['dstY'] ?? 0,
      );
    }

    File(outputPath).writeAsBytesSync(img.encodeJpg(collage, quality: 100));
    return outputPath;
  });
}
