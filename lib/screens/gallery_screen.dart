import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:flutterbooth/models/config/extensions/app_config_image_widgets.dart';
import 'package:flutterbooth/screens/result_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  void _loadImages() {
    final directory = Directory(widget.imageFolder);
    if (directory.existsSync()) {
      final files = directory.listSync()
          .where((file) => lookupMimeType(file.path)?.startsWith('image/') == true)
          .map((file) => file.path)
          .toList();

      files.sort((a, b) => File(b).lastModifiedSync().compareTo(File(a).lastModifiedSync()));

      setState(() {
        allImages = files;
      });
    }
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
