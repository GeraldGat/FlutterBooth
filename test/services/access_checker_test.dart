import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbooth/models/config/app_config.dart';
import 'package:flutterbooth/services/access_checker.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

void main() {
  group('AccessChecker', () {
    testWidgets('checkAdminAccess returns true when no password is set',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          final config = AppConfig(
            settings:
                const AppConfig().settings.copyWith(adminPassword: null),
          );
          AccessChecker.checkAdminAccess(context, config).then((result) {
            expect(result, isTrue);
          });
          return const SizedBox.shrink();
        }),
      ));
    });

    testWidgets('checkAdminAccess returns true when password is empty',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          final config = AppConfig(
            settings:
                const AppConfig().settings.copyWith(adminPassword: ''),
          );
          AccessChecker.checkAdminAccess(context, config).then((result) {
            expect(result, isTrue);
          });
          return const SizedBox.shrink();
        }),
      ));
    });

    test('sha256 hash verification works correctly', () {
      const password = 'admin123';
      const hashed = '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9';
      final computed = sha256.convert(utf8.encode(password)).toString();
      expect(computed, hashed);
    });

    test('different passwords produce different hashes', () {
      final hash1 = sha256.convert(utf8.encode('password1')).toString();
      final hash2 = sha256.convert(utf8.encode('password2')).toString();
      expect(hash1, isNot(equals(hash2)));
    });
  });
}
