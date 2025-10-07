import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutterbooth/models/app_config.dart';

class AccessChecker {
  static Future<bool> checkAdminAccess(BuildContext context, AppConfig config) async {
    if (config.adminPassword?.isEmpty ?? true) return true;

    final controller = TextEditingController();
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
              final inputHash = sha256.convert(utf8.encode(controller.text)).toString();
              Navigator.pop(context, inputHash == config.adminPassword);
            },
          ),
        ],
      ),
    );
    return ok ?? false;
  }
}