import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutterbooth/models/app_config.dart';
import 'package:flutterbooth/models/extensions/app_config_colors.dart';
import 'package:flutterbooth/models/extensions/app_config_widgets.dart';
import 'package:flutterbooth/screens/result_screen.dart';
import 'package:flutterbooth/widgets/fb_keyboard_actions.dart';
import 'package:mime/mime.dart';

class GalleryScreen extends StatefulWidget {
  final String imageFolder;
  final AppConfig appConfig;

  const GalleryScreen({super.key, required this.imageFolder, required this.appConfig});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<String> allImages = [];

  int currentPage = 0;
  int selectedIndex = 1;
  List<(bool, Function)> get actionList {
    return [
      (currentPage > 0, _previousPage),
      (true, _openSelectedImage),
      (currentImages.length > 1, _openSelectedImage),
      (currentImages.length > 2, _openSelectedImage),
      (currentImages.length > 3, _openSelectedImage),
      ((currentPage + 1) * 4 < allImages.length, _nextPage),
      (true, _closeScreen),
    ];
  }
  
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
      setState(() {
        allImages = files;
      });
    }
  }

  List<String> get currentImages {
    final start = currentPage * 4;
    final end = (start + 4).clamp(0, allImages.length);
    return allImages.sublist(start, end);
  }

  void _previousPage() {
    setState(() {
      currentPage--;
    });
  }

  void _nextPage() {
    setState(() {
      currentPage++;
    });
  }

  void _closeScreen() {
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _openSelectedImage() {
    _openImage(selectedIndex);
  }

  int _getNextAvailableIndex(int step) {
    int nextIndex = selectedIndex;

    for (int i = 0; i < actionList.length; i++) {
      nextIndex = (nextIndex + step + 7) % 7;
      if (actionList[nextIndex].$1 == true) {
        return nextIndex;
      }
    }

    return selectedIndex;
  }

  void _handlePrev() {
    setState(() => selectedIndex = _getNextAvailableIndex(-1));
  }

  void _handleNext() {
    setState(() => selectedIndex = _getNextAvailableIndex(1));
  }

  void _handleEnter() {
    if (actionList[selectedIndex].$1 == true) {
      actionList[selectedIndex].$2.call();
    }
  }

  void _openImage(int index) {
    if (index < currentImages.length) {
      final path = currentImages[index];
      final imageWidget = Image.file(File(path));
      
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              appConfig: widget.appConfig,
              image: imageWidget,
            ),
          ),
        );
        // TODO: Change ResultScreen return and delete image from list if removed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const spacing = 10.0;
    final screenSize = MediaQuery.of(context).size;
    final availableWidth = screenSize.width - (96 + 10) * 2; // espace pour les boutons gauche/droite
    final availableHeight = screenSize.height * 0.9;
    double imageHeight = (availableHeight - spacing) / 2;
    double imageWidth = imageHeight * 3 / 2;

    if (availableWidth < (imageWidth * 2 + spacing)) {
      imageWidth = (availableWidth - spacing) / 2;
      imageHeight = imageWidth * 2 / 3;
    }

    return FbKeyboardActions(
      onPrevious: _handlePrev,
      onNext: _handleNext,
      onConfirm: _handleEnter,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            widget.appConfig.gallery(
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            // Bouton précédent (gauche)
            if (actionList[0].$1 == true)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    onPressed: _previousPage,
                    icon: widget.appConfig.prevIcon(
                      width: 96,
                      height: 96,
                      colorFilter:
                          ColorFilter.mode(selectedIndex == 0 ? widget.appConfig.mainColor : widget.appConfig.accentColor, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            
            // Images centrales
            Center(
              child: SizedBox(
                width: imageWidth * 2 + spacing,
                height: imageHeight * 2 + spacing,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: 3/2,
                  ),
                  itemCount: currentImages.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndex == index + 1;
                    return GestureDetector(
                      onTap: () => setState(() => selectedIndex = index + 1),
                      onDoubleTap: () => _openImage(index),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected 
                                ? widget.appConfig.mainColor
                                : Colors.transparent,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(currentImages[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Bouton suivant (droite)
            if (actionList[5].$1 == true)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    onPressed: _nextPage,
                    icon: widget.appConfig.nextIcon(
                      width: 96,
                      height: 96,
                      colorFilter:
                          ColorFilter.mode(selectedIndex == 5 ? widget.appConfig.mainColor : widget.appConfig.accentColor, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),

            // Bouton fermer (en haut à droite)
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: _closeScreen,
                icon: widget.appConfig.closeIcon(
                  width: 96,
                  height: 96,
                  colorFilter:
                      ColorFilter.mode(selectedIndex == 6 ? widget.appConfig.mainColor : widget.appConfig.accentColor, BlendMode.srcIn),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}