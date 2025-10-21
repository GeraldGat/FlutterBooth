import 'package:flutter/material.dart';
import 'package:flutterbooth/models/app_config.dart';
import 'package:flutterbooth/models/extensions/app_config_colors.dart';
import 'package:flutterbooth/models/extensions/app_config_widgets.dart';
import 'package:flutterbooth/widgets/fb_keyboard_actions.dart';
import 'package:flutterbooth/widgets/rotationg_menu.dart';

class ResultScreen extends StatefulWidget {
  final Image image;
  final AppConfig appConfig;

  const ResultScreen({super.key, required this.appConfig, required this.image});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final GlobalKey<RotatingMenuState> menuKey = GlobalKey<RotatingMenuState>();
  late AppConfig _config;
  late Image _image;

  @override
  void initState() {
    super.initState();
    _config = widget.appConfig;
    _image = widget.image;
  }

  void _handlePrev() {
    menuKey.currentState?.movePrevious();
  }

  void _handleNext() {
    menuKey.currentState?.moveNext();
  }

  void _handleEnter() {
    try {
      (menuKey.currentState?.selected as dynamic).onPressed?.call();
    } catch (e) {
      // Ignore si pas de bouton sélectionné
    }
  }

  @override
  Widget build(BuildContext context) {
    return FbKeyboardActions(
      onPrevious: _handlePrev,
      onNext: _handleNext,
      onConfirm: _handleEnter,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Fond
            _config.result(),

            // Image centrale
            Center(
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 130),
                  child: _image,
                ),
              ),
            ),

            // Menu en bas
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: RotatingMenu(
                  key: menuKey,
                  displayedChildren: 3,
                  children: [
                    // Back
                    IconButton(
                      onPressed: () {
                        if (mounted) {
                          Navigator.pop(context, true);
                        }
                      },
                      icon: _config.backIcon(
                        width: 48,
                        height: 48,
                        colorFilter: ColorFilter.mode(
                          _config.mainColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    // Print
                    IconButton(
                      onPressed: () {
                        // TODO: Action print
                      },
                      icon: _config.printIcon(
                        width: 48,
                        height: 48,
                        colorFilter: ColorFilter.mode(
                          _config.mainColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    // Remove
                    IconButton(
                      onPressed: () {
                        if (_image.image is FileImage) {
                          final file = (_image.image as FileImage).file;
                          if (file.existsSync()) {
                            file.deleteSync();
                            if (mounted) {
                              Navigator.pop(context, true);
                            }
                          }
                        }
                      },
                      icon: _config.removeIcon(
                        width: 48,
                        height: 48,
                        colorFilter: ColorFilter.mode(
                          _config.mainColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
