import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterbooth/models/extensions/app_config_colors.dart';
import 'package:flutterbooth/models/extensions/app_config_widgets.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:flutterbooth/widgets/fb_keyboard_actions.dart';
import 'package:flutterbooth/widgets/rotationg_menu.dart';

class ResultScreen extends ConsumerStatefulWidget {
  final Image image;

  const ResultScreen({super.key, required this.image});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  final GlobalKey<RotatingMenuState> menuKey = GlobalKey<RotatingMenuState>();

  @override
  void initState() {
    super.initState();
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
      // If no button is selected, ignore
    }
  }

  @override
  Widget build(BuildContext context) {
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
              config.result(),

              Center(
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Container(
                    margin: const EdgeInsets.only(top: 50, bottom: 130),
                    child: widget.image,
                  ),
                ),
              ),

              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: RotatingMenu(
                    key: menuKey,
                    displayedChildren: 3,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (mounted) {
                            Navigator.pop(context, true);
                          }
                        },
                        icon: config.backIcon(
                          width: 48,
                          height: 48,
                          colorFilter: ColorFilter.mode(
                            config.mainColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // TODO: Action print
                        },
                        icon: config.printIcon(
                          width: 48,
                          height: 48,
                          colorFilter: ColorFilter.mode(
                            config.mainColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (widget.image.image is FileImage) {
                            final file = (widget.image.image as FileImage).file;
                            if (file.existsSync()) {
                              file.deleteSync();
                              if (mounted) {
                                Navigator.pop(context, true);
                              }
                            }
                          }
                        },
                        icon: config.removeIcon(
                          width: 48,
                          height: 48,
                          colorFilter: ColorFilter.mode(
                            config.mainColor,
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
