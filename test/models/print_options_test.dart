import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbooth/models/print_options.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  group('PrintOptions', () {
    test('defaults are correct', () {
      const options = PrintOptions();
      expect(options.format.width, 10 * PdfPageFormat.cm);
      expect(options.format.height, 15 * PdfPageFormat.cm);
      expect(options.orientation, PrintOrientation.auto);
      expect(options.imageFit, pw.BoxFit.cover);
      expect(options.printerName, isNull);
      expect(options.copies, 1);
      expect(options.backgroundColor, PdfColors.white);
    });

    test('copies must be >= 1', () {
      expect(
        () => PrintOptions(copies: 0),
        throwsAssertionError,
      );
    });

    test('custom values are stored', () {
      const options = PrintOptions(
        format: PhotoPrintFormat.r20x25,
        orientation: PrintOrientation.landscape,
        copies: 3,
        printerName: 'TestPrinter',
        imageFit: pw.BoxFit.contain,
        backgroundColor: PdfColors.black,
      );
      expect(options.format.width, 20 * PdfPageFormat.cm);
      expect(options.format.height, 25 * PdfPageFormat.cm);
      expect(options.orientation, PrintOrientation.landscape);
      expect(options.copies, 3);
      expect(options.printerName, 'TestPrinter');
      expect(options.imageFit, pw.BoxFit.contain);
      expect(options.backgroundColor, PdfColors.black);
    });
  });

  group('PhotoPrintFormat', () {
    test('r9x12 has correct dimensions', () {
      expect(PhotoPrintFormat.r9x12.width, 9 * PdfPageFormat.cm);
      expect(PhotoPrintFormat.r9x12.height, 12 * PdfPageFormat.cm);
    });

    test('r10x15 has correct dimensions', () {
      expect(PhotoPrintFormat.r10x15.width, 10 * PdfPageFormat.cm);
      expect(PhotoPrintFormat.r10x15.height, 15 * PdfPageFormat.cm);
    });

    test('r13x18 has correct dimensions', () {
      expect(PhotoPrintFormat.r13x18.width, 13 * PdfPageFormat.cm);
      expect(PhotoPrintFormat.r13x18.height, 18 * PdfPageFormat.cm);
    });

    test('r20x25 has correct dimensions', () {
      expect(PhotoPrintFormat.r20x25.width, 20 * PdfPageFormat.cm);
      expect(PhotoPrintFormat.r20x25.height, 25 * PdfPageFormat.cm);
    });

    test('r22x28 has correct dimensions', () {
      expect(PhotoPrintFormat.r22x28.width, 22 * PdfPageFormat.cm);
      expect(PhotoPrintFormat.r22x28.height, 28 * PdfPageFormat.cm);
    });
  });

  group('PrintOrientation enum', () {
    test('has three values', () {
      expect(PrintOrientation.values.length, 3);
      expect(PrintOrientation.values, contains(PrintOrientation.portrait));
      expect(PrintOrientation.values, contains(PrintOrientation.landscape));
      expect(PrintOrientation.values, contains(PrintOrientation.auto));
    });
  });
}
