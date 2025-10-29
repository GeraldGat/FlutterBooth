import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterbooth/models/extensions/app_config_colors.dart';
import 'package:flutterbooth/models/extensions/app_config_widgets.dart';
import 'package:flutterbooth/providers/config_provider.dart';

class CountdownAndCaptureScreen extends ConsumerStatefulWidget {
  final void Function()? onCapture;

  const CountdownAndCaptureScreen({super.key, this.onCapture});

  @override
  ConsumerState<CountdownAndCaptureScreen> createState() => _CountdownAndCaptureScreenState();
}

class _CountdownAndCaptureScreenState extends ConsumerState<CountdownAndCaptureScreen> {
  int _counter = 3;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _counter--;
      });
      if (_counter == 0) {
        if (widget.onCapture != null) {
          widget.onCapture!();
        }
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget background;
    String text;

    final asyncConfig = ref.watch(configProvider);

    return asyncConfig.when(
      data: (config) {
        switch (_counter) {
          case 3:
            background = config.countdown3();
            text = "3";
            break;
          case 2:
            background = config.countdown2();
            text = "2";
            break;
          case 1:
            background = config.countdown1();
            text = "1";
            break;
          default:
            background = config.capture();
            text = config.captureText;
        }

        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              background,
              Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontFamily: config.fontFamilyName,
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: config.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error loading config: $error')),
      ),
    );
  }
}
