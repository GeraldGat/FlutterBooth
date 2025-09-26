import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbooth/models/app_config.dart';
import 'package:flutterbooth/models/extensions/app_config_colors.dart';
import 'package:flutterbooth/models/extensions/app_config_widgets.dart';
import 'package:flutterbooth/widgets/rotationg_menu.dart';
import 'package:window_manager/window_manager.dart';

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
  late bool _isFullscreen;

  @override
  void initState() {
    super.initState();
    _config = widget.appConfig;
    _image = widget.image;
    _initFullscreen();
  }

  Future<void> _initFullscreen() async {
    _isFullscreen = await WindowManager.instance.isFullScreen();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Focus(autofocus: true,
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
            // Fond
            _config.result(),

            // Image centrale
            Center(
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 50),
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
                        // TODO: action remove
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
                    // Back
                    IconButton(
                      onPressed: () {
                        // TODO: action back
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
