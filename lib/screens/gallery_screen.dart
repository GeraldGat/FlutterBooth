import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:flutterbooth/models/config/extensions/app_config_image_widgets.dart';
import 'package:flutterbooth/screens/result_screen.dart';
import 'package:flutterbooth/utils/cancellable.dart';
import 'package:flutterbooth/widgets/paged_grid_screen.dart';
import 'package:mime/mime.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  final String imageFolder;

  const GalleryScreen({super.key, required this.imageFolder});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {
  List<String> allImages = [];
  Cancellable? _loadImagesOperation;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  @override
  void dispose() {
    _loadImagesOperation?.cancel();
    super.dispose();
  }

  Future<void> _loadImages() async {
    final operation = Cancellable();
    _loadImagesOperation = operation;

    final directory = Directory(widget.imageFolder);
    if (!await directory.exists()) return;
    if (operation.isCancelled) return;

    final files = await directory.list().toList();
    if (operation.isCancelled) return;

    final filesWithDates = <(String, DateTime)>[];
    for (final entity in files) {
      if (operation.isCancelled) return;
      if (lookupMimeType(entity.path)?.startsWith('image/') == true) {
        final modified = await File(entity.path).lastModified();
        if (operation.isCancelled) return;
        filesWithDates.add((entity.path, modified));
      }
    }

    filesWithDates.sort((a, b) => b.$2.compareTo(a.$2));
    final filesWithDatesList = filesWithDates.map((e) => e.$1).toList();

    operation.run(() {
      setState(() {
        allImages = filesWithDatesList;
      });
    });
  }

  Future<void> _openImage(int index) async {
    if (index < allImages.length) {
      final path = allImages[index];
      final imageWidget = Image.file(File(path));

      if (context.mounted) {
        final resultScreenReturn = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              image: imageWidget,
            ),
          ),
        );

        if (resultScreenReturn == ResultScreenReturn.delete) {
          setState(() {
            allImages.removeAt(index);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedGridScreen(
      totalItemCount: allImages.length,
      backgroundBuilder: (config) => config.gallery(
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
      itemContentBuilder: (config, index) => Image.file(
        File(allImages[index]),
        fit: BoxFit.cover,
      ),
      onItemSelected: _openImage,
      onItemDoubleTap: _openImage,
    );
  }
}
