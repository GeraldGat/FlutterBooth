import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterbooth/exceptions/gphoto2_exception.dart';
import 'package:flutterbooth/models/config/extensions/app_config_colors.dart';
import 'package:flutterbooth/models/config/extensions/app_config_icon_widgets.dart';
import 'package:flutterbooth/models/config/extensions/app_config_image_widgets.dart';
import 'package:flutterbooth/models/four_collage.dart';
import 'package:flutterbooth/models/two_collage.dart';
import 'package:flutterbooth/models/two_plus_one_collage.dart';
import 'package:flutterbooth/providers/access_checker_provider.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:flutterbooth/screens/collage_screen.dart';
import 'package:flutterbooth/screens/countdown_and_capture_screen.dart';
import 'package:flutterbooth/screens/gallery_screen.dart';
import 'package:flutterbooth/screens/result_screen.dart';
import 'package:flutterbooth/providers/capture_service_provider.dart';
import 'package:flutterbooth/screens/settings_screen.dart';
import 'package:flutterbooth/services/logger/app_logger.dart';
import 'package:flutterbooth/widgets/fb_keyboard_actions.dart';
import 'package:flutterbooth/widgets/rotating_menu.dart';
import 'package:google_fonts/google_fonts.dart';

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
    menuKey.currentState?.selectedCallback?.call();
  }

  Future<void> _openSettings() async {
    final configAsync = ref.read(configProvider);
    if (!configAsync.hasValue || configAsync.value == null) return;

    final accessCheckerService = ref.read(accessCheckerProvider);
    final allowed = await accessCheckerService.checkAdminAccess(context, configAsync.value!);
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
                    config.settings.homeText,
                    style: GoogleFonts.getFont(
                      config.texts.fontFamilyName,
                      fontSize: config.texts.homeFontSize,
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
                  items: [
                    RotatingMenuItem(
                      onPressed: () async {
                        final captureService = ref.read(captureServiceProvider(tempFolderPath: config.settings.fileSavePath, gphotoPort: config.settings.gphotoPort));
                        if (!context.mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CountdownAndCaptureScreen(
                              onCapture: () async {
                                void showCaptureError(BuildContext context) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("An error occured while capturing image.")),
                                  );
                                  Navigator.pop(context);
                                }

                                try {
                                  final path = await captureService.capture();

                                  if(!context.mounted) return;

                                  final imageFile = File(path);

                                  if (!imageFile.existsSync()) {
                                    showCaptureError(context);
                                    return;
                                  }

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ResultScreen(
                                        image: Image.file(imageFile),
                                      ),
                                    ),
                                  );
                                } on GPhoto2Exception catch (e) {
                                  AppLogger.e('GPhoto2 capture failed', e);
                                  if(!context.mounted) return;

                                  showCaptureError(context);
                                  return;
                                }
                              },
                            ),
                          ),
                        );
                      },
                      child: IconButton(
                        onPressed: null,
                        icon: config.photoIcon(
                          width: 48,
                          height: 48,
                          colorFilter:
                              ColorFilter.mode(config.mainColor, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    RotatingMenuItem(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GalleryScreen(
                              imageFolder: config.settings.fileSavePath,
                            ),
                          ),
                        );
                      },
                      child: IconButton(
                        onPressed: null,
                        icon: config.galleryIcon(
                          width: 48,
                          height: 48,
                          colorFilter:
                              ColorFilter.mode(config.mainColor, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    RotatingMenuItem(
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
                      child: IconButton(
                        onPressed: null,
                        icon: config.collageIcon(
                          width: 48,
                          height: 48,
                          colorFilter:
                              ColorFilter.mode(config.mainColor, BlendMode.srcIn),
                        ),
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