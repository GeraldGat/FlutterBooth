import 'package:flutter/material.dart';
import 'package:flutterbooth/widgets/fb_keyboard_listener.dart';
import 'package:window_manager/window_manager.dart';

class FbKeyboardActions extends StatelessWidget {
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onConfirm;
  final VoidCallback? onSettings;
  final Widget child;
  
  const FbKeyboardActions({
    super.key,
    this.onPrevious,
    this.onNext,
    this.onConfirm,
    this.onSettings,
    required this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        if (onPrevious != null)
          NavigatePreviousIntent: CallbackAction<NavigatePreviousIntent>(
            onInvoke: (_) => onPrevious!(),
          ),
        if (onNext != null)
          NavigateNextIntent: CallbackAction<NavigateNextIntent>(
            onInvoke: (_) => onNext!(),
          ),
        if (onConfirm != null)
          ConfirmIntent: CallbackAction<ConfirmIntent>(
            onInvoke: (_) => onConfirm!(),
          ),
        if (onSettings != null)
          SettingsIntent: CallbackAction<SettingsIntent>(
            onInvoke: (_) => onSettings!(),
          ),
        FullscreenIntent: CallbackAction<FullscreenIntent>(
          onInvoke: (_) {
            final windowInstance = WindowManager.instance;
            windowInstance.isFullScreen().then((isFullScreen) => windowInstance.setFullScreen(!isFullScreen));
            return null;
          },
        ),
        ExitFullscreenIntent: CallbackAction<ExitFullscreenIntent>(
          onInvoke: (_) {
            WindowManager.instance.setFullScreen(false);
            return null;
          },
        ),
      },
      child: Focus(
        autofocus: true,
        child: child,
      ),
    );
  }
}