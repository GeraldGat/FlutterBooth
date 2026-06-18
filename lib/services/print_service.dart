import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutterbooth/models/print_options.dart';
import 'package:flutterbooth/models/print_result.dart';

class PrintServiceException implements Exception {
  final String message;
  const PrintServiceException(this.message);

  @override
  String toString() => 'PrintServiceException: $message';
}

class PrintService {
  Future<PrintResult> printImageBytes(
    Uint8List imageBytes, {
    PrintOptions options = const PrintOptions(),
  }) async {
    try {
      final pdfBytes = await _buildPdf(imageBytes, options);
      return await _sendToPrinter(pdfBytes, options);
    } on PrintServiceException catch (e) {
      return PrintResult.failure(e.message);
    } catch (e) {
      return PrintResult.failure('Unexpected error : $e');
    }
  }

  Future<PrintResult> printAssetImage(
    String assetPath, {
    PrintOptions options = const PrintOptions(),
  }) async {
    try {
      final data = await rootBundle.load(assetPath);
      return printImageBytes(data.buffer.asUint8List(), options: options);
    } catch (e) {
      return PrintResult.failure(
        "Can't load asset \"$assetPath\" : $e",
      );
    }
  }

  Future<PrintResult> printFile(
    File file, {
    PrintOptions options = const PrintOptions(),
  }) async {
    if (!file.existsSync()) {
      return PrintResult.failure(
        'File not found : ${file.path}',
      );
    }

    final int fileSize;
    try {
      fileSize = await file.length();
    } catch (e) {
      return PrintResult.failure(
        'Can\'t read file "${file.path}" : $e',
      );
    }

    if (fileSize == 0) {
      return PrintResult.failure('The file is empty : ${file.path}');
    }

    try {
      final imageBytes = await file.readAsBytes();
      return printImageBytes(imageBytes, options: options);
    } on FileSystemException catch (e) {
      return PrintResult.failure(
        'System error when reading "${file.path}" : ${e.message}',
      );
    } catch (e) {
      return PrintResult.failure(
        'Unexpected error when reading : $e',
      );
    }
  }


  Future<Uint8List> _buildPdf(
    Uint8List imageBytes,
    PrintOptions options,
  ) async {
    final imageInfo = await _decodeImageInfo(imageBytes);
    final imageWidth = imageInfo.width.toDouble();
    final imageHeight = imageInfo.height.toDouble();

    final pageFormat = _resolvePageFormat(options, imageWidth, imageHeight);

    final pdf = pw.Document();
    final pwImage = pw.MemoryImage(imageBytes);

    for (var i = 0; i < options.copies; i++) {
      pdf.addPage(
        pw.Page(
          pageFormat: pageFormat,
          margin: pw.EdgeInsets.zero,
          build: (pw.Context ctx) => pw.Container(
            color: options.backgroundColor,
            width: pageFormat.width,
            height: pageFormat.height,
            child: _buildImageWidget(pwImage, options),
          ),
        ),
      );
    }

    return pdf.save();
  }

  /// Build PDF image widget based on [PrintImageFit]
  pw.Widget _buildImageWidget(pw.MemoryImage image, PrintOptions options) {
    switch (options.imageFit) {
      case pw.BoxFit.contain:
        return pw.Center(child: pw.Image(image, fit: options.imageFit));
      default:
        return pw.Image(image, fit: options.imageFit);
    }
  }

  PdfPageFormat _resolvePageFormat(
    PrintOptions options,
    double imageWidth,
    double imageHeight,
  ) {
    final PdfPageFormat base = options.format;

    final isImageLandscape = imageWidth > imageHeight;

    switch (options.orientation) {
      case PrintOrientation.landscape:
        return base.landscape;
      case PrintOrientation.portrait:
        return base.portrait;
      case PrintOrientation.auto:
        if (isImageLandscape && base.width < base.height) {
          return base.landscape;
        }
        if (!isImageLandscape && base.width > base.height) {
          return base.portrait;
        }
        return base;
    }
  }

  Future<PrintResult> _sendToPrinter(
    Uint8List pdfBytes,
    PrintOptions options,
  ) async {
    final info = await Printing.info();
    if (!info.canPrint) {
      throw const PrintServiceException(
        "Printing is not supported on this platform.",
      );
    }

    if (info.directPrint) {
      Printer? targetPrinter;
      final printers = await Printing.listPrinters();

      if (options.printerName != null) {
        targetPrinter = printers.firstWhere(
          (p) => p.name == options.printerName,
          orElse: () => throw PrintServiceException(
            'Printer "${options.printerName}" not found.',
          ),
        );
      } else {
        targetPrinter = printers.firstWhere(
          (p) => p.isDefault,
          orElse: () => throw PrintServiceException(
            'No default printer found.',
          ),
        );
      }

      final success = await Printing.directPrintPdf(
        printer: targetPrinter,
        onLayout: (_) async => pdfBytes,
      );

      return success
          ? PrintResult.success()
          : PrintResult.failure("The direct print failed.");
    } else {
      await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
      return PrintResult.success();
    }
  }

  Future<ui.Image> _decodeImageInfo(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}