import 'package:flutter/material.dart';
import 'package:flutterbooth/models/config/app_config.dart';
import 'package:flutterbooth/services/access_checker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'access_checker_provider.g.dart';

@riverpod
AccessCheckerService accessChecker(Ref ref) {
  return AccessCheckerService();
}

class AccessCheckerService {
  Future<bool> checkAdminAccess(BuildContext context, AppConfig config) async {
    return AccessChecker.checkAdminAccess(context, config);
  }
}