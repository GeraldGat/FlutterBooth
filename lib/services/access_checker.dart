import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutterbooth/models/config/app_config.dart';

class AccessChecker {
  static Future<bool> checkAdminAccess(BuildContext context, AppConfig config) async {
    if (config.settings.adminPassword?.isEmpty ?? true) return true;

    final controller = TextEditingController();
    final salt = config.settings.passwordSalt ?? "";
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Password required"),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(labelText: "Admin password"),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text("OK"),
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