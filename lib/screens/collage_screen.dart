import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:flutterbooth/models/app_config.dart';
import 'package:flutterbooth/models/collage.dart';
import 'package:flutterbooth/models/extensions/app_config_colors.dart';
import 'package:flutterbooth/models/extensions/app_config_widgets.dart';
import 'package:flutterbooth/screens/countdown_and_capture_screen.dart';
import 'package:flutterbooth/screens/result_screen.dart';
import 'package:flutterbooth/services/capture_service.dart';

class CollageScreen extends StatefulWidget {
  final AppConfig appConfig;
  final List<Collage> collages;

  const CollageScreen({super.key, required this.appConfig, required this.collages});

  @override
  State<CollageScreen> createState() => _CollageScreenState();
}

class _CollageScreenState extends State<CollageScreen> {
  int currentPage = 0;
  int selectedIndex = 0;
  final FocusNode _focusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool get canGoPrevious => currentPage > 0;
  bool get canGoNext => (currentPage + 1) * 4 < widget.collages.length;

  void _goToPrevious() {
    if (canGoPrevious) {
      setState(() {
        currentPage--;
      });
    }
  }

  void _goToNext() {
    if (canGoNext) {
      setState(() {
        currentPage++;
      });
    }
  }

  void _makeCollage(Collage collage) async {
    final tempDir = "/home/ggatouillat/Development/flutterbooth/temp"; // ou un dossier configuré dans ton app
    final captureService = CaptureService(tempDir);
    final List<String> capturedImages = [];

    for (int i = 0; i < collage.imageCount; i++) {
      // Étape 1 : afficher le décompte avant chaque capture
      if (mounted) {
        capturedImages.add(await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CountdownAndCaptureScreen(
              appConfig: widget.appConfig,
              onCapture: () async {
                final path = await captureService.capture();

                if (path != null && mounted) {
                  Navigator.pop(context, path);
                }
              },
            ),
          ),
        ));
      }
    }

    // Étape 3 : construire le collage final
    final outputPath = "$tempDir/collage_${DateTime.now().millisecondsSinceEpoch}.jpg";
    final success = collage.buildCollage(capturedImages, outputPath);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            appConfig: widget.appConfig,
            image: Image.file(File(outputPath)),
          ),
        ),
      );
    }
  }

  void _handleKeyPress(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        setState(() => selectedIndex = (selectedIndex - 1 + 7) % 7);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        setState(() => selectedIndex = (selectedIndex + 1 + 7) % 7);
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (selectedIndex == 4) {
          _goToPrevious();
        } else if (selectedIndex == 5) {
          _goToNext();
        } else if (selectedIndex == 6) {
          if (mounted) {
            Navigator.of(context).pop();
          }
        } else {
          _makeCollage(widget.collages[currentPage * 4 + selectedIndex]);
        }
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

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyPress,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            widget.appConfig.gallery(
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
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
                  itemCount: widget.collages.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => selectedIndex = index),
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
                            File(widget.collages[index].thumbnailAsset),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Bouton précédent (gauche)
            if (canGoPrevious)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      _goToPrevious();
                    },
                    icon: widget.appConfig.prevIcon(
                      width: 96,
                      height: 96,
                      colorFilter:
                          ColorFilter.mode(selectedIndex == 4 ? widget.appConfig.mainColor : widget.appConfig.accentColor, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),

            // Bouton suivant (droite)
            if (canGoNext)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      _goToNext();
                    },
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
                onPressed: () {
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                },
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