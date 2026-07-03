import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterbooth/models/config/extensions/app_config_colors.dart';
import 'package:flutterbooth/models/config/extensions/app_config_icon_widgets.dart';
import 'package:flutterbooth/models/config/extensions/app_config_image_widgets.dart';
import 'package:flutterbooth/models/print_result.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:flutterbooth/services/print_service.dart';
import 'package:flutterbooth/widgets/fb_keyboard_actions.dart';
import 'package:flutterbooth/widgets/rotating_menu.dart';

enum ResultScreenReturn {
  back,
  print,
  delete,
}

class ResultScreen extends ConsumerStatefulWidget {
  final Image image;

  const ResultScreen({super.key, required this.image});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  final GlobalKey<RotatingMenuState> menuKey = GlobalKey<RotatingMenuState>();

  void _handlePrev() {
    menuKey.currentState?.movePrevious();
  }

  void _handleNext() {
    menuKey.currentState?.moveNext();
  }

  void _handleEnter() {
    menuKey.currentState?.selectedCallback?.call();
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
                    items: [
                      RotatingMenuItem(
                        onPressed: () {
                          if (mounted) {
                            Navigator.pop(context, ResultScreenReturn.back);
                          }
                        },
                        child: IconButton(
                          onPressed: null,
                          icon: config.backIcon(
                            width: 48,
                            height: 48,
                            colorFilter: ColorFilter.mode(
                              config.mainColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      RotatingMenuItem(
                        onPressed: () async {
                          if (widget.image.image is FileImage) {
                            final file = (widget.image.image as FileImage).file;
                            PrintService service = PrintService();
                            PrintResult printResult = await service.printFile(file);
                            if (context.mounted) {
                              if (printResult.success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Printing...")),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("An error occured during printing.")),
                                );
                              }
                            }
                          }
                        },
                        child: IconButton(
                          onPressed: null,
                          icon: config.printIcon(
                            width: 48,
                            height: 48,
                            colorFilter: ColorFilter.mode(
                              config.mainColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      RotatingMenuItem(
                        onPressed: () {
                          if (widget.image.image is FileImage) {
                            final file = (widget.image.image as FileImage).file;
                            if (file.existsSync()) {
                              file.deleteSync();
                              if (mounted) {
                                Navigator.pop(context, ResultScreenReturn.delete);
                              }
                            }
                          }
                        },
                        child: IconButton(
                          onPressed: null,
                          icon: config.removeIcon(
                            width: 48,
                            height: 48,
                            colorFilter: ColorFilter.mode(
                              config.mainColor,
                              BlendMode.srcIn,
                            ),
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
