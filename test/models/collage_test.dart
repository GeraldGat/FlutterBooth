import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbooth/models/collage.dart';
import 'package:flutterbooth/models/two_collage.dart';
import 'package:flutterbooth/models/two_plus_one_collage.dart';
import 'package:flutterbooth/models/four_collage.dart';
import 'package:flutterbooth/exceptions/collage_exception.dart';
import 'package:image/image.dart' as img;

void main() {
  group('TwoCollage', () {
    test('has correct image count', () {
      expect(TwoCollage().imageCount, 2);
    });

    test('has non-empty thumbnail asset', () {
      expect(TwoCollage().thumbnailAsset, isNotEmpty);
    });

    test('has correct layout items count', () {
      expect(TwoCollage().layoutItems.length, 2);
    });

    test('canvas dimensions are positive', () {
      final collage = TwoCollage();
      expect(collage.canvasWidth, greaterThan(0));
      expect(collage.canvasHeight, greaterThan(0));
    });
  });

  group('TwoPlusOneCollage', () {
    test('has correct image count', () {
      expect(TwoPlusOneCollage().imageCount, 3);
    });

    test('has correct layout items count', () {
      expect(TwoPlusOneCollage().layoutItems.length, 3);
    });
  });

  group('FourCollage', () {
    test('has correct image count', () {
      expect(FourCollage().imageCount, 4);
    });

    test('has correct layout items count', () {
      expect(FourCollage().layoutItems.length, 4);
    });
  });

  group('copyResizeAndCrop', () {
    test('throws ArgumentError for non-positive dimensions', () {
      final image = img.Image(width: 100, height: 100);
      expect(
        () => copyResizeAndCrop(image, width: 0, height: 100),
        throwsArgumentError,
      );
      expect(
        () => copyResizeAndCrop(image, width: 100, height: 0),
        throwsArgumentError,
      );
    });

    test('returns image of exact target dimensions', () {
      final image = img.Image(width: 200, height: 100);
      final result = copyResizeAndCrop(image, width: 50, height: 50);
      expect(result.width, 50);
      expect(result.height, 50);
    });

    test('handles landscape source to portrait target', () {
      final image = img.Image(width: 400, height: 200);
      final result = copyResizeAndCrop(image, width: 100, height: 200);
      expect(result.width, 100);
      expect(result.height, 200);
    });

    test('handles portrait source to landscape target', () {
      final image = img.Image(width: 200, height: 400);
      final result = copyResizeAndCrop(image, width: 400, height: 200);
      expect(result.width, 400);
      expect(result.height, 200);
    });

    test('handles square source to square target', () {
      final image = img.Image(width: 300, height: 300);
      final result = copyResizeAndCrop(image, width: 150, height: 150);
      expect(result.width, 150);
      expect(result.height, 150);
    });
  });

  group('CollageException', () {
    test('stores message and details', () {
      const exception = CollageException('test error', details: 'detail info');
      expect(exception.message, 'test error');
      expect(exception.details, 'detail info');
    });

    test('toString includes message and details', () {
      const exception = CollageException('err', details: 'det');
      expect(exception.toString(), contains('err'));
      expect(exception.toString(), contains('det'));
    });

    test('details can be null', () {
      const exception = CollageException('only message');
      expect(exception.details, isNull);
    });
  });

  group('Collage abstract class behavior', () {
    test('all concrete collages satisfy abstract contract', () {
      final collages = [TwoCollage(), TwoPlusOneCollage(), FourCollage()];
      for (final c in collages) {
        expect(c.imageCount, greaterThan(0));
        expect(c.thumbnailAsset, isNotEmpty);
        expect(c.layoutItems.length, c.imageCount);
        expect(c.canvasWidth, 3000);
        expect(c.canvasHeight, 2000);
        for (final item in c.layoutItems) {
          expect(item.containsKey('rotation'), isTrue);
          expect(item.containsKey('targetWidth'), isTrue);
          expect(item.containsKey('targetHeight'), isTrue);
          expect(item.containsKey('dstX'), isTrue);
          expect(item.containsKey('dstY'), isTrue);
        }
      }
    });
  });
}
