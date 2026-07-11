import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterbooth/exceptions/collage_exception.dart';
import 'package:flutterbooth/exceptions/gphoto2_exception.dart';
import 'dart:io';

import 'package:flutterbooth/models/collage.dart';
import 'package:flutterbooth/models/config/extensions/app_config_image_widgets.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:flutterbooth/screens/countdown_and_capture_screen.dart';
import 'package:flutterbooth/screens/result_screen.dart';
import 'package:flutterbooth/providers/capture_service_provider.dart';
import 'package:flutterbooth/screens/home_screen.dart';
import 'package:flutterbooth/services/logger/app_logger.dart';
import 'package:flutterbooth/widgets/paged_grid_screen.dart';
import 'package:path_provider/path_provider.dart';

class CollageScreen extends ConsumerStatefulWidget {
  final List<Collage> collages;

  const CollageScreen({super.key, required this.collages});

  @override
  ConsumerState<CollageScreen> createState() => _CollageScreenState();
}

class _CollageScreenState extends ConsumerState<CollageScreen> {
  Future<void> _makeCollage(int index) async {
    final collage = widget.collages[index];
    final tempDir = await getTemporaryDirectory();
    final captureService = ref.read(captureServiceProvider(tempFolderPath: tempDir.path, gphotoPort: ref.read(configProvider).requireValue.settings.gphotoPort));
    final List<String> capturedImages = [];

    for (int i = 0; i < collage.imageCount; i++) {
      if (mounted) {
        final captureReturn = await Navigator.push<Object?>(
          context,
          MaterialPageRoute(
            builder: (_) => CountdownAndCaptureScreen(
              onCapture: () async {
                try {
                  final path = await captureService.capture();

                  if(!mounted) return;

                  Navigator.pop(context, path);
                } on GPhoto2Exception catch (e) {
                  AppLogger.e('GPhoto2 capture failed during collage', e);
                  if(!mounted) return;

                  Navigator.pop(context, false);
                }
              },
            ),
          ),
        );

        if (captureReturn == false) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("An error occured while capturing image.")),
            );
            Navigator.pop(context);
          }
          return;
        }

        capturedImages.add(captureReturn as String);
      }
    }

    final outputPath = "${ref.read(configProvider).requireValue.settings.fileSavePath}/collage_${DateTime.now().millisecondsSinceEpoch}.jpg";

    try {
      await buildCollageInIsolate(
        canvasWidth: collage.canvasWidth,
        canvasHeight: collage.canvasHeight,
        layout: collage.layoutItems,
        imagePaths: capturedImages,
        outputPath: outputPath,
      );

      if(!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            image: Image.file(File(outputPath)),
          ),
        ),
      );
    } on CollageException catch (e) {
      AppLogger.e('Collage build failed', e);
      if(!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    } catch (e, s) {
      AppLogger.e('Unexpected error during collage build', e, s);
      if(!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An unexpected error occurred.")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedGridScreen(
      totalItemCount: widget.collages.length,
      backgroundBuilder: (config) => config.collage(
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
      itemContentBuilder: (config, index) => Image.asset(
        widget.collages[index].thumbnailAsset,
        fit: BoxFit.cover,
      ),
      onItemSelected: _makeCollage,
    );
  }
}
