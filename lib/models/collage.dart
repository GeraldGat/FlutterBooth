abstract class Collage {
  int get imageCount;
  String get thumbnailAsset;

  /// Returns a image path that arranges the given [images] in the collage layout.
  /// The length of [images] will always be equal to [imageCount].
  bool buildCollage(List<String> images, String outputPath);
}