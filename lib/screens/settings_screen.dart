import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutterbooth/models/config/app_config.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'settings/icons_tab.dart';
import 'settings/settings_tab.dart';
import 'settings/shortcuts_tab.dart';
import 'settings/texts_tab.dart';
import 'settings/wallpapers_tab.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentIndex = 0;
  final _passwordController = TextEditingController();
  bool _passwordEverModified = false;
  AppConfig? _config;
  List<String>? _cachedFonts;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _onConfigChanged(AppConfig newConfig) {
    setState(() => _config = newConfig);
  }

  void _onPasswordModified(bool modified) {
    _passwordEverModified = modified;
  }

  Future<void> _saveConfig() async {
    final config = _config!;

    final settings = config.settings;
    String? passwordHash;
    String? passwordSalt;

    final password = _passwordController.text;
    if (_passwordEverModified && password.isEmpty) {
      passwordHash = "";
      passwordSalt = null;
    } else if (_passwordEverModified && password.isNotEmpty) {
      final salt = base64Encode(List<int>.generate(16, (_) => Random.secure().nextInt(256)));
      passwordHash = sha256.convert(utf8.encode(password + salt)).toString();
      passwordSalt = salt;
    } else {
      passwordHash = settings.adminPassword;
      passwordSalt = settings.passwordSalt;
    }

    final toSave = config.copyWith(
      settings: settings.copyWith(
        adminPassword: passwordHash,
        passwordSalt: passwordSalt,
      ),
    );

    await ref.read(configProvider.notifier).save(toSave);
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncConfig = ref.watch(configProvider);

    return asyncConfig.when(
      data: (config) {
        if (_config == null) {
          _config = config;
          if (config.settings.adminPassword?.isNotEmpty == true) {
            _passwordController.text = "p";
          }
        }
        final tabs = ["Settings", "Wallpapers", "Icons", "Texts", "Shortcuts"];
        final fonts = _cachedFonts ??= GoogleFonts.asMap().keys.toList()..sort();

        return DefaultTabController(
          length: tabs.length,
          initialIndex: _currentIndex,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Configuration"),
              bottom: TabBar(
                labelColor: Colors.black,
                tabs: [for (final t in tabs) Tab(text: t)],
                onTap: (i) => setState(() => _currentIndex = i),
              ),
            ),
            body: Form(
              key: _formKey,
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  SettingsTab(
                    config: _config!,
                    onChanged: _onConfigChanged,
                    passwordController: _passwordController,
                    passwordEverModified: _passwordEverModified,
                    onPasswordModified: _onPasswordModified,
                  ),
                  WallpapersTab(config: _config!, onChanged: _onConfigChanged),
                  IconsTab(config: _config!, onChanged: _onConfigChanged),
                  TextsTab(config: _config!, onChanged: _onConfigChanged, fonts: fonts),
                  ShortcutsTab(config: _config!, onChanged: _onConfigChanged),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _saveConfig,
              backgroundColor: Colors.deepPurple,
              foregroundColor: const Color(0xFFF0F0F0),
              child: const Icon(Icons.save),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(child: Text('Error loading config: $error')),
      ),
    );
  }
}
