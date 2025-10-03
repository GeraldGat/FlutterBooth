import 'dart:io';
import 'package:uuid/uuid.dart';

class CaptureService {
  final String _tempFolderPath;

  CaptureService(this._tempFolderPath);

  Future<String?> capture() async {
    final filename = "${Uuid().v4()}.jpg";
    final fullPath = "$_tempFolderPath/$filename";

    try {
      final result = await Process.run(
        'gphoto2',
        [
          '--capture-image-and-download',
          '--filename=$fullPath'
        ]
      );

      if (result.exitCode == 0) {
        return fullPath;
      }
    } catch (e) {
      // Erreur si problème avec gphoto2
    }
    return null;
  }
}