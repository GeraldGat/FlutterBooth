import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:flutterbooth/models/collage.dart';
import 'package:flutterbooth/models/extensions/app_config_colors.dart';
import 'package:flutterbooth/models/extensions/app_config_widgets.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:flutterbooth/screens/countdown_and_capture_screen.dart';
import 'package:flutterbooth/screens/result_screen.dart';
import 'package:flutterbooth/widgets/fb_keyboard_actions.dart';
import 'package:flutterbooth/services/capture_service.dart';

class CollageScreen extends ConsumerStatefulWidget {
  final List<Collage> collages;

  const CollageScreen({super.key, required this.collages});

  @override
  ConsumerState<CollageScreen> createState() => _CollageScreenState();
}

class _CollageScreenState extends ConsumerState<CollageScreen> {
  int currentPage = 0;
  int selectedIndex = 1;
  List<(bool, Function)> get actionList {
    return [
      (currentPage > 0, _previousPage),
      (true, _makeSelectedCollage),
      (currentCollages.length > 1, _makeSelectedCollage),
      (currentCollages.length > 2, _makeSelectedCollage),
      (currentCollages.length > 3, _makeSelectedCollage),
      ((currentPage + 1) * 4 < widget.collages.length, _nextPage),
      (true, _closeScreen),
    ];
  }

  List<Collage> get currentCollages {
    final start = currentPage * 4;
    final end = (start + 4).clamp(0, widget.collages.length);
    return widget.collages.sublist(start, end);
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

  void _makeSelectedCollage() {
    _makeCollage(currentCollages[selectedIndex]);
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

  void _makeCollage(Collage collage) async {
    final tempDir = "/home/ggatouillat/Development/flutterbooth/temp"; // TODO: change path
    final captureService = CaptureService(tempDir);
    final List<String> capturedImages = [];

    for (int i = 0; i < collage.imageCount; i++) {
      if (mounted) {
        capturedImages.add(await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CountdownAndCaptureScreen(
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

    final outputPath = "$tempDir/collage_${DateTime.now().millisecondsSinceEpoch}.jpg";
    final success = collage.buildCollage(capturedImages, outputPath);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            image: Image.file(File(outputPath)),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const spacing = 10.0;
    final screenSize = MediaQuery.of(context).size;
    final availableWidth = screenSize.width - (96 + 10) * 2;
    final availableHeight = screenSize.height * 0.9;
    double imageHeight = (availableHeight - spacing) / 2;
    double imageWidth = imageHeight * 3 / 2;

    if (availableWidth < (imageWidth * 2 + spacing)) {
      imageWidth = (availableWidth - spacing) / 2;
      imageHeight = imageWidth * 2 / 3;
    }

    final asyncConfig = ref.watch(configProvider);

    return asyncConfig.when(
      data: (config) => FbKeyboardActions(
        onPrevious: _handlePrev,
        onNext: _handleNext,
        onConfirm: _handleEnter,
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              config.collage(
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),

              if (actionList[0].$1 == true)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton(
                      onPressed: _previousPage,
                      icon: config.prevIcon(
                        width: 96,
                        height: 96,
                        colorFilter:
                            ColorFilter.mode(selectedIndex == 4 ? config.mainColor : config.accentColor, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
              
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
                    itemCount: currentCollages.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndex == index + 1;
                      return GestureDetector(
                        onTap: () => setState(() => selectedIndex = index + 1),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected 
                                  ? config.mainColor
                                  : Colors.transparent,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(currentCollages[index].thumbnailAsset),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              if (actionList[5].$1 == true)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton(
                      onPressed: _nextPage,
                      icon: config.nextIcon(
                        width: 96,
                        height: 96,
                        colorFilter:
                            ColorFilter.mode(selectedIndex == 5 ? config.mainColor : config.accentColor, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),

              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: _closeScreen,
                  icon: config.closeIcon(
                    width: 96,
                    height: 96,
                    colorFilter:
                        ColorFilter.mode(selectedIndex == 6 ? config.mainColor : config.accentColor, BlendMode.srcIn),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error loading config: $error')),
      ),
    );
  }
}