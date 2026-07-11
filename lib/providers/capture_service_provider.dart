import 'package:flutterbooth/services/capture_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'capture_service_provider.g.dart';

@riverpod
CaptureService captureService(Ref ref, {required String tempFolderPath, String? gphotoPort}) {
  return CaptureService(tempFolderPath, gphotoPort);
}
