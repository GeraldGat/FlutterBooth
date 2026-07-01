
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PhotoPrintFormat {

  static const PdfPageFormat r9x12 = PdfPageFormat(
    9 * PdfPageFormat.cm,
    12 * PdfPageFormat.cm
  );

  static const PdfPageFormat r10x15 = PdfPageFormat(
    10 * PdfPageFormat.cm,
    15 * PdfPageFormat.cm
  );

  static const PdfPageFormat r13x18 = PdfPageFormat(
    13 * PdfPageFormat.cm,
    18 * PdfPageFormat.cm
  );

  static const PdfPageFormat r20x25 = PdfPageFormat(
    20 * PdfPageFormat.cm,
    25 * PdfPageFormat.cm
  );

  static const PdfPageFormat r22x28 = PdfPageFormat(
    22 * PdfPageFormat.cm,
    28 * PdfPageFormat.cm
  );
}

enum PrintOrientation {
  portrait,
  landscape,
  auto,
}

class PrintOptions {
  final PdfPageFormat format;
  final PrintOrientation orientation;
  final pw.BoxFit imageFit;

  // Printer name (null = default printer).
  final String? printerName;
  final int copies;

  final PdfColor backgroundColor;
  

  const PrintOptions({
    this.format = PhotoPrintFormat.r10x15,
    this.orientation = PrintOrientation.auto,
    this.printerName,
    this.copies = 1,
    this.imageFit = pw.BoxFit.cover,
    this.backgroundColor = PdfColors.white,
  }) : assert(copies >= 1, 'Copies parameter should be at least 1.');
}