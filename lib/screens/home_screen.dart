import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterbooth/models/extensions/app_config_colors.dart';
import 'package:flutterbooth/models/extensions/app_config_widgets.dart';
import 'package:flutterbooth/models/four_collage.dart';
import 'package:flutterbooth/models/two_collage.dart';
import 'package:flutterbooth/models/two_plus_one_collage.dart';
import 'package:flutterbooth/providers/access_checker_provider.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:flutterbooth/screens/collage_screen.dart';
import 'package:flutterbooth/screens/countdown_and_capture_screen.dart';
import 'package:flutterbooth/screens/gallery_screen.dart';
import 'package:flutterbooth/screens/result_screen.dart';
import 'package:flutterbooth/screens/settings_screen.dart';
import 'package:flutterbooth/services/capture_service.dart';
import 'package:flutterbooth/widgets/fb_keyboard_actions.dart';
import 'package:flutterbooth/widgets/rotationg_menu.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<RotatingMenuState> menuKey = GlobalKey();

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
      // If no button is selected, ignore
    }
  }

  Future<void> _openSettings() async {
    final accessCheckerService = ref.read(accessCheckerProvider);

    final allowed = await accessCheckerService.checkAdminAccess(context);
    if (!allowed) return;
    if (!mounted) return;
    
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncConfig = ref.watch(configProvider);

    return asyncConfig.when(
      data: (config) => FbKeyboardActions(
        onPrevious: _handlePrev,
        onNext: _handleNext,
        onConfirm: _handleEnter,
        onSettings: _openSettings,
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              config.mainWallpaper(
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  config.eventLogo(
                    height: MediaQuery.of(context).size.height * 0.6,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    config.homeText,
                    style: TextStyle(
                      fontSize: 40,
                      color: config.textColor,
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
                      onPressed: () async {
                        final temporaryPath = await getTemporaryDirectory();
                        final captureService = CaptureService(temporaryPath.path);
                        if (!context.mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CountdownAndCaptureScreen(
                              onCapture: () async {
                                final path = await captureService.capture();

                                if (path != null && File(path).existsSync()) {
                                  final imageWidget = Image.file(File(path));

                                  if (context.mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ResultScreen(
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
                      icon: config.photoIcon(
                        width: 48,
                        height: 48,
                        colorFilter:
                            ColorFilter.mode(config.mainColor, BlendMode.srcIn),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GalleryScreen(
                              imageFolder: "/home/ggatouillat/Development/flutterbooth/temp",
                            ),
                          ),
                        );
                      },
                      icon: config.galleryIcon(
                        width: 48,
                        height: 48,
                        colorFilter:
                            ColorFilter.mode(config.mainColor, BlendMode.srcIn),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CollageScreen(
                              collages: [
                                TwoCollage(),
                                TwoPlusOneCollage(),
                                FourCollage(),
                              ],
                            ),
                          ),
                        );
                      },
                      icon: config.collageIcon(
                        width: 48,
                        height: 48,
                        colorFilter:
                            ColorFilter.mode(config.mainColor, BlendMode.srcIn),
                      ),
                    ),
                  ],
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