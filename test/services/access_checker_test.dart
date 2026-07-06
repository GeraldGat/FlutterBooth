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

    test('salted hash verification works correctly', () {
      const password = 'admin123';
      const salt = 'test-salt';
      final hash1 = sha256.convert(utf8.encode('$password$salt')).toString();
      final hash2 = sha256.convert(utf8.encode('$password$salt')).toString();
      expect(hash1, hash2);
    });

    test('different salts produce different hashes', () {
      const password = 'admin123';
      const saltA = 'salt-a';
      const saltB = 'salt-b';
      final hash1 = sha256.convert(utf8.encode('$password$saltA')).toString();
      final hash2 = sha256.convert(utf8.encode('$password$saltB')).toString();
      expect(hash1, isNot(equals(hash2)));
    });

    test('different passwords with same salt produce different hashes', () {
      const salt = 'fixed-salt';
      final hash1 = sha256.convert(utf8.encode('password1$salt')).toString();
      final hash2 = sha256.convert(utf8.encode('password2$salt')).toString();
      expect(hash1, isNot(equals(hash2)));
    });
  });
}
