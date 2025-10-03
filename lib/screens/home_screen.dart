import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbooth/models/app_config.dart';
import 'package:flutterbooth/models/extensions/app_config_colors.dart';
import 'package:flutterbooth/models/extensions/app_config_widgets.dart';
import 'package:flutterbooth/screens/countdown_and_capture_screen.dart';
import 'package:flutterbooth/screens/result_screen.dart';
import 'package:flutterbooth/screens/settings_screen.dart';
import 'package:flutterbooth/services/access_checker.dart';
import 'package:flutterbooth/services/capture_service.dart';
import 'package:flutterbooth/services/config_service.dart';
import 'package:flutterbooth/widgets/rotationg_menu.dart';
import 'package:window_manager/window_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.config});

  final AppConfig config;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RotatingMenuState> menuKey = GlobalKey();

  late AppConfig _config;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _config = widget.config;
  }

  Future<void> _openSettings() async {
    // Vérification du mot de passe avant ouverture
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
        _config = newConfig ?? _config; // fallback si null
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Config reloaded")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey.keyId == _config.shortcutEnterLogicalKeyId) {
              try {
                (menuKey.currentState?.selected as dynamic).onPressed?.call();
              } catch (e) {
                return KeyEventResult.ignored;
              }
              return KeyEventResult.handled;
          }

          if (event.logicalKey.keyId == _config.shortcutPrevLogicalKeyId) {
            menuKey.currentState?.movePrevious();
            return KeyEventResult.handled;
          }

          if (event.logicalKey.keyId == _config.shortcutNextLogicalKeyId) {
            menuKey.currentState?.moveNext();
            return KeyEventResult.handled;
          }

          if (event.logicalKey.keyId == _config.shortcutSettingsLogicalKeyId) {
            _openSettings();
            return KeyEventResult.handled;
          }

          if (event.logicalKey == LogicalKeyboardKey.f11) {
            _isFullscreen = !_isFullscreen;
            WindowManager.instance.setFullScreen(_isFullscreen);
            return KeyEventResult.handled;
          }

          if (event.logicalKey == LogicalKeyboardKey.escape && _isFullscreen) {
            _isFullscreen = !_isFullscreen;
            WindowManager.instance.setFullScreen(_isFullscreen);
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
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
                // Logo
                _config.eventLogo(
                  height: MediaQuery.of(context).size.height * 0.6,
                  fit: BoxFit.contain,
                ),
                // Texte
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
                  // Bouton Photo
                  IconButton(
                    onPressed: () {
                      final captureService = CaptureService("/home/ggatouillat/Development/flutterbooth/temp");
                      // On pousse l'écran de décompte
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
                                  // Gestion d'erreur si la capture échoue
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Erreur lors de la capture de la photo")),
                                  );
                                }

                                // Retour à l’écran précédent
                                Navigator.pop(context);
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
                  // Bouton Galerie
                  IconButton(
                    onPressed: () {
                      // TODO: action galerie
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
                      // TODO: action collage
                    },
                    icon: _config.collageIcon(
                      width: 48,
                      height: 48,
                      colorFilter:
                          ColorFilter.mode(_config.mainColor, BlendMode.srcIn),
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
