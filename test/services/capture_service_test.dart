import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbooth/exceptions/gphoto2_exception.dart';
import 'package:flutterbooth/services/capture_service.dart';

void main() {
  group('CaptureService', () {
    test('capture throws GPhoto2Exception when gphoto2 is not available',
        () async {
      final service = CaptureService('/tmp');
      expect(
        () => service.capture(),
        throwsA(isA<GPhoto2Exception>()),
      );
    });

    test(
        'capture with port specified throws GPhoto2Exception when gphoto2 is not available',
        () async {
      final service = CaptureService('/tmp', 'usb:001,002');
      expect(
        () => service.capture(),
        throwsA(isA<GPhoto2Exception>()),
      );
    });

    test('capture exception contains the gphoto options', () async {
      final service = CaptureService('/tmp', 'usb:001,002');
      try {
        await service.capture();
        fail('Expected GPhoto2Exception');
      } on GPhoto2Exception catch (e) {
        expect(
          e.options.any((o) => o.startsWith('--filename=/tmp/')),
          isTrue,
        );
        expect(e.options, contains('--capture-image-and-download'));
        expect(e.options, contains('--port=usb:001,002'));
      }
    });
  });
}
