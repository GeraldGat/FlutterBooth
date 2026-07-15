import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutterbooth/l10n/app_localizations.dart';
import 'package:flutterbooth/models/config/app_config.dart';

class AccessChecker {
  static Future<bool> checkAdminAccess(BuildContext context, AppConfig config) async {
    if (config.settings.adminPassword?.isEmpty ?? true) return true;

    final controller = TextEditingController();
    final salt = config.settings.passwordSalt ?? "";
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.passwordRequired),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.adminPasswordField),
        ),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.ok),
            onPressed: () {
              final inputHash = sha256.convert(utf8.encode(controller.text + salt)).toString();
              Navigator.pop(context, inputHash == config.settings.adminPassword);
            },
          ),
        ],
      ),
    );
    controller.dispose();
    return ok ?? false;
  }
}