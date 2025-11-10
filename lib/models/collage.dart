import 'package:image/image.dart' as img;

abstract class Collage {
  int get imageCount;
  String get thumbnailAsset;

  /// Returns a image path that arranges the given [images] in the collage layout.
  /// The length of [images] will always be equal to [imageCount].
  bool buildCollage(List<String> images, String outputPath);

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
      // Image source plus "large" → ajuster en hauteur
      resizeWidth = (height * srcRatio).ceil();
      resizeHeight = height;
    } else {
      // Image source plus "haute" → ajuster en largeur
      resizeWidth = width;
      resizeHeight = (width / srcRatio).ceil();
    }

    final resized = img.copyResize(src, width: resizeWidth, height: resizeHeight, maintainAspect: true);

    final xOffset = (resizeWidth - width) ~/ 2;
    final yOffset = (resizeHeight - height) ~/ 2;

    return img.copyCrop(resized, x: xOffset, y: yOffset, width: width, height: height);
  }
}