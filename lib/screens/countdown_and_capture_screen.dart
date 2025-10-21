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

    switch (_counter) {
      case 3:
        background = widget.appConfig.countdown3();
        text = "3";
        break;
      case 2:
        background = widget.appConfig.countdown2();
        text = "2";
        break;
      case 1:
        background = widget.appConfig.countdown1();
        text = "1";
        break;
      default:
        background = widget.appConfig.capture();
        text = widget.appConfig.captureText;
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
                fontFamily: widget.appConfig.fontFamilyName,
                fontSize: 100,
                fontWeight: FontWeight.bold,
                color: widget.appConfig.textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
