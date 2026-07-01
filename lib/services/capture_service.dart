import 'dart:io';
import 'package:flutterbooth/exceptions/gphoto2_exception.dart';
import 'package:uuid/uuid.dart';

class CaptureService {
  final String _tempFolderPath;
  final String? _gphotoPort;

  CaptureService(this._tempFolderPath, [ this._gphotoPort ]);

  Future<String> capture() async {
    final filename = "${Uuid().v4()}.jpg";
    final fullPath = "$_tempFolderPath/$filename";

    List<String> gphotoOptions = [
      '--capture-image-and-download',
      '--filename=$fullPath',
      if (_gphotoPort != null) '--port=$_gphotoPort'
    ];

    try {
      final result = await Process.run(
        'gphoto2',
        gphotoOptions
      );

      if (result.exitCode != 0) {
        throw GPhoto2Exception("GPhoto2 failed", gphotoOptions);
      }

      return fullPath;
    } catch (e) {
        if(e is GPhoto2Exception) rethrow;

        throw GPhoto2Exception("Unexpected error while running gphoto2", gphotoOptions);
    }
  }
}