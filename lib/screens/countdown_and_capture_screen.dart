import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterbooth/models/app_config.dart';
import 'package:flutterbooth/models/extensions/app_config_colors.dart';
import 'package:flutterbooth/models/extensions/app_config_widgets.dart';

class CountdownAndCaptureScreen extends StatefulWidget {
  final AppConfig appConfig;
  final void Function()? onCapture;

  const CountdownAndCaptureScreen({super.key, required this.appConfig, this.onCapture});

  @override
  State<CountdownAndCaptureScreen> createState() => _CountdownAndCaptureScreenState();
}

class _CountdownAndCaptureScreenState extends State<CountdownAndCaptureScreen> {
  late AppConfig _config;
  int _counter = 3;

  @override
  void initState() {
    super.initState();
    _config = widget.appConfig;
    _startCountdown();
  }

  void _startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter == 0) {
        if (widget.onCapture != null) {
          widget.onCapture!();
        }
        timer.cancel();
      } else {
        setState(() {
          _counter--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget background;
    String text;

    switch (_counter) {
      case 3:
        background = _config.countdown3();
        text = "3";
        break;
      case 2:
        background = _config.countdown2();
        text = "2";
        break;
      case 1:
        background = _config.countdown1();
        text = "1";
        break;
      default:
        background = _config.capture();
        text = _config.captureText;
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
                fontFamily: _config.fontFamilyName,
                fontSize: 100,
                fontWeight: FontWeight.bold,
                color: _config.textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
