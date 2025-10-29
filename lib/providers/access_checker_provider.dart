import 'package:flutter/material.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:flutterbooth/services/access_checker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'access_checker_provider.g.dart';

@riverpod
AccessCheckerService accessChecker(Ref ref) {
  return AccessCheckerService(ref);
}

class AccessCheckerService {
  final Ref ref;
  AccessCheckerService(this.ref);

  Future<bool> checkAdminAccess(BuildContext context) async {
    final configAsync = ref.read(configProvider);

    if(configAsync.value == null) {
      return false;
    }

    return AccessChecker.checkAdminAccess(context, configAsync.value!);
  }
}