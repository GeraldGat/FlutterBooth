import 'package:flutter/foundation.dart';

class Cancellable {
  bool _isCancelled = false;

  void cancel() => _isCancelled = true;

  bool get isCancelled => _isCancelled;

  void run(VoidCallback action) {
    if (!_isCancelled) action();
  }
}
