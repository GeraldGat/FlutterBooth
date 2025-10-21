import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterbooth/models/app_config.dart';
import 'package:flutterbooth/models/extensions/app_config_colors.dart';
import 'package:flutterbooth/models/extensions/app_config_widgets.dart';
import 'package:flutterbooth/models/four_collage.dart';
import 'package:flutterbooth/models/two_collage.dart';
import 'package:flutterbooth/models/two_plus_one_collage.dart';
import 'package:flutterbooth/screens/collage_screen.dart';
import 'package:flutterbooth/screens/countdown_and_capture_screen.dart';
import 'package:flutterbooth/screens/gallery_screen.dart';
import 'package:flutterbooth/screens/result_screen.dart';
import 'package:flutterbooth/screens/settings_screen.dart';
import 'package:flutterbooth/services/access_checker.dart';
import 'package:flutterbooth/services/capture_service.dart';
import 'package:flutterbooth/services/config_service.dart';
import 'package:flutterbooth/widgets/fb_keyboard_actions.dart';
import 'package:flutterbooth/widgets/rotationg_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.config});

  final AppConfig config;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RotatingMenuState> menuKey = GlobalKey();

  late AppConfig _config;

  @override
  void initState() {
    super.initState();
    _config = widget.config;
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

  Future<void> _openSettings() async {
    final allowed = await AccessChecker.checkAdminAccess(context, _config);
    if (!allowed) return;
    if (!mounted) return;
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(initialConfig: _config),
      ),
    );

    if (result == true) {
      final newConfig = await ConfigService().loadConfig();
      setState(() {
        _config = newConfig ?? _config;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Config reloaded")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FbKeyboardActions(
      onPrevious: _handlePrev,
      onNext: _handleNext,
      onConfirm: _handleEnter,
      onSettings: _openSettings,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            _config.mainWallpaper(
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _config.eventLogo(
                  height: MediaQuery.of(context).size.height * 0.6,
                  fit: BoxFit.contain,
                ),
                Text(
                  _config.homeText,
                  style: TextStyle(
                    fontSize: 40,
                    color: _config.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.05,
              left: 0,
              right: 0,
              child: RotatingMenu(
                key: menuKey,
                displayedChildren: 3,
                children: [
                  IconButton(
                    onPressed: () {
                      final captureService = CaptureService("/home/ggatouillat/Development/flutterbooth/temp");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CountdownAndCaptureScreen(
                            appConfig: _config,
                            onCapture: () async {
                              final path = await captureService.capture();

                              if (path != null && File(path).existsSync()) {
                                final imageWidget = Image.file(File(path));

                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ResultScreen(
                                        appConfig: _config,
                                        image: imageWidget,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Erreur lors de la capture de la photo")),
                                  );
                                  Navigator.pop(context);
                                }
                              }
                            },
                          ),
                        ),
                      );
                    },
                    icon: _config.photoIcon(
                      width: 48,
                      height: 48,
                      colorFilter:
                          ColorFilter.mode(_config.mainColor, BlendMode.srcIn),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GalleryScreen(
                            imageFolder: "/home/ggatouillat/Development/flutterbooth/temp",
                            appConfig: _config,
                          ),
                        ),
                      );
                    },
                    icon: _config.galleryIcon(
                      width: 48,
                      height: 48,
                      colorFilter:
                          ColorFilter.mode(_config.mainColor, BlendMode.srcIn),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CollageScreen(
                            appConfig: _config,
                            collages: [
                              TwoCollage(),
                              TwoPlusOneCollage(),
                              FourCollage(),
                            ],
                          ),
                        ),
                      );
                    },
                    icon: _config.collageIcon(
                      width: 48,
                      height: 48,
                      colorFilter:
                          ColorFilter.mode(_config.mainColor, BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}