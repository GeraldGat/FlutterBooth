import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbooth/services/print_service.dart';

void main() {
  group('PrintService', () {
    late PrintService service;

    setUp(() {
      service = PrintService();
    });

    group('printFile', () {
      test('returns failure for non-existent file', () async {
        final file = File('/nonexistent/path/image.jpg');
        final result = await service.printFile(file);
        expect(result.success, isFalse);
        expect(result.errorMessage, contains('File not found'));
      });

      test('returns failure for empty file', () async {
        final tempDir = Directory.systemTemp.createTempSync('print_test_');
        final file = File('${tempDir.path}/empty.jpg');
        file.createSync();

        final result = await service.printFile(file);
        expect(result.success, isFalse);
        expect(result.errorMessage, contains('empty'));

        tempDir.deleteSync(recursive: true);
      });

      test('returns failure for unreadable file path', () async {
        final tempDir = Directory.systemTemp.createTempSync('print_test_');
        final file = File('${tempDir.path}/valid.jpg');
        file.writeAsBytesSync([0x01, 0x02, 0x03]);

        final result = await service.printFile(file);
        expect(result.success, isFalse);

        tempDir.deleteSync(recursive: true);
      });
    });

    group('printAssetImage', () {
      test('returns failure for invalid asset path', () async {
        final result = await service.printAssetImage('nonexistent_asset.png');
        expect(result.success, isFalse);
        expect(result.errorMessage, contains("Can't load asset"));
      });
    });

    group('printImageBytes', () {
      test('returns failure for empty bytes', () async {
        final result = await service.printImageBytes(Uint8List(0));
        expect(result.success, isFalse);
      });

      test('returns failure for invalid image bytes', () async {
        final result = await service.printImageBytes(Uint8List.fromList([0x00, 0x01, 0x02]));
        expect(result.success, isFalse);
      });
    });
  });
}
