import 'dart:io';
import 'package:uuid/uuid.dart';

class CaptureService {
  final String _tempFolderPath;
  final String? _gphotoPort;

  CaptureService(this._tempFolderPath, [ this._gphotoPort ]);

  Future<String?> capture() async {
    final filename = "${Uuid().v4()}.jpg";
    final fullPath = "$_tempFolderPath/$filename";

    try {
      List<String> gphotoOptions = [
        '--capture-image-and-download',
        '--filename=$fullPath'
      ];

      if (_gphotoPort != null) {
        gphotoOptions.add('--port=$_gphotoPort');
      }

      final result = await Process.run(
        'gphoto2',
        gphotoOptions
      );

      if (result.exitCode == 0) {
        return fullPath;
      }
    } catch (e) {
       // Error in gphoto2 execution
    }
    return null;
  }
}