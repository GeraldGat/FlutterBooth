import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:crypto/crypto.dart';
import 'package:flutterbooth/models/extensions/app_config_colors.dart';
import 'package:flutterbooth/models/extensions/app_config_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/app_config.dart';
import '../services/config_service.dart';

class SettingsPage extends StatefulWidget {
  final AppConfig initialConfig;

  const SettingsPage({super.key, required this.initialConfig});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late AppConfig _config;
  final _formKey = GlobalKey<FormState>();
  int _currentIndex = 0;
  List<String> fonts = [];

  @override
  void initState() {
    super.initState();
    _config = widget.initialConfig;
    fonts = GoogleFonts.asMap().keys.toList()..sort();
  }

  Future<void> _pickFile(Function(String) onSelected,
      {List<String>? allowedExtensions}) async {
    final result = await FilePicker.platform.pickFiles(
      type: allowedExtensions == null ? FileType.any : FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    if (result != null && result.files.single.path != null) {
      onSelected(result.files.single.path!);
    }
  }

  /// Sauvegarde avec hash du mot de passe
  Future<void> _saveConfig() async {
    final toSave = _config.copyWith(
      adminPassword: _config.adminPassword!.isEmpty
          ? ""
          : sha256.convert(utf8.encode(_config.adminPassword ?? "")).toString(),
    );

    await ConfigService().saveConfig(toSave);
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  /// Champ texte générique
  Widget _buildTextField(String label, String value, Function(String) onChanged,
      {bool obscure = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        initialValue: value,
        obscureText: obscure,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        onChanged: onChanged,
      ),
    );
  }

  /// Champ selection font
  Widget _buildFontFamilyField(String label, String value, Function(String) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        items: fonts.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
        onChanged: (val) => onChanged(val ?? value),
      ),
    );
  }

  /// Champ couleur avec preview
  Widget _buildColorField(String label, Color color, String value, Function(String) onChanged) {
    final controller = TextEditingController(text: value);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () async {
              final picked = await showDialog<Color>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Pick a color for $label"),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: color,
                      onColorChanged: (c) => color = c,
                    ),
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                    TextButton(onPressed: () => Navigator.pop(context, color), child: const Text("Select")),
                  ],
                ),
              );
              if (picked != null) {
                final hex = picked.toARGB32().toRadixString(16).substring(2).toUpperCase();
                controller.text = hex;
                onChanged(hex);
                setState(() {});
              }
            },
            child: Container(width: 32, height: 32, color: color),
          ),
        ],
      ),
    );
  }

  /// Champ fichier image avec preview
  Widget _buildImageField(String label, Widget image, String? path, Function(String) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          image,
          const SizedBox(width: 4),
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: TextEditingController(text: path),
              decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: () => _pickFile(onChanged, allowedExtensions: ["png", "jpg", "jpeg"]),
          ),
        ],
      ),
    );
  }

  /// Champ fichier SVG avec preview
  Widget _buildSvgField(String label, Widget svg, String? path, Function(String) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          svg,
          const SizedBox(width: 4),
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: TextEditingController(text: path),
              decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: () => _pickFile(onChanged, allowedExtensions: ["svg"]),
          ),
        ],
      ),
    );
  }

  /// Champ raccourci clavier
  Widget _buildShortcutField(String label, int keyId, Function(int) onChanged) {
    final controller = TextEditingController(text: LogicalKeyboardKey(keyId).keyLabel);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            final key = event.logicalKey;
            controller.text = key.keyLabel;
            onChanged(key.keyId);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        ),
      ),
    );
  }

@override
Widget build(BuildContext context) {
  final tabs = ["Settings", "Wallpapers", "Icons", "Texts", "Shortcuts"];

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
            _buildSettingsTab(),
            _buildWallpapersTab(),
            _buildIconsTab(),
            _buildTextsTab(),
            _buildShortcutsTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveConfig,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Color(0xFFF0F0F0),
        child: const Icon(Icons.save),
      ),
    ),
  );
}


  /// Onglet Settings
  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        _buildImageField("Event Logo", _config.eventLogo(width: 80, height: 80), _config.eventLogoPath,
            (v) => setState(() => _config = _config.copyWith(eventLogoPath: v))),
        _buildTextField("Home text", _config.homeText,
            (v) => setState(() => _config = _config.copyWith(homeText: v))),
        _buildColorField("Main color", _config.mainColor, _config.mainColorHex,
            (v) => setState(() => _config = _config.copyWith(mainColorHex: v))),
        _buildColorField("Accent color", _config.accentColor, _config.accentColorHex,
            (v) => setState(() => _config = _config.copyWith(accentColorHex: v))),
        _buildTextField("Admin panel password", _config.adminPassword ?? "",
            (v) => setState(() => _config = _config.copyWith(adminPassword: v)),
            obscure: true),
      ],
    );
  }

  /// Onglet Wallpapers
  Widget _buildWallpapersTab() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        _buildImageField("Main wallpaper", _config.mainWallpaper(width: 80, height: 80), _config.mainWallpaperPath,
            (v) => setState(() => _config = _config.copyWith(mainWallpaperPath: v))),
        _buildImageField("Countdown 3", _config.countdown3(width: 80, height: 80), _config.countdown3Path,
            (v) => setState(() => _config = _config.copyWith(countdown3Path: v))),
        _buildImageField("Countdown 2", _config.countdown2(width: 80, height: 80), _config.countdown2Path,
            (v) => setState(() => _config = _config.copyWith(countdown2Path: v))),
        _buildImageField("Countdown 1", _config.countdown1(width: 80, height: 80), _config.countdown1Path,
            (v) => setState(() => _config = _config.copyWith(countdown1Path: v))),
        _buildImageField("Capture", _config.capture(width: 80, height: 80), _config.capturePath,
            (v) => setState(() => _config = _config.copyWith(capturePath: v))),
        _buildImageField("Result", _config.result(width: 80, height: 80), _config.resultPath,
            (v) => setState(() => _config = _config.copyWith(resultPath: v))),
        _buildImageField("Gallery", _config.gallery(width: 80, height: 80), _config.galleryPath,
            (v) => setState(() => _config = _config.copyWith(galleryPath: v))),
        _buildImageField("Collage", _config.collage(width: 80, height: 80), _config.collagePath,
            (v) => setState(() => _config = _config.copyWith(collagePath: v))),
      ],
    );
  }

  /// Onglet Icons
  Widget _buildIconsTab() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        _buildSvgField("Photo", _config.photoIcon(width: 40, height: 40), _config.photoIconPath,
            (v) => setState(() => _config = _config.copyWith(photoIconPath: v))),
        _buildSvgField("Gallery", _config.galleryIcon(width: 40, height: 40), _config.galleryIconPath,
            (v) => setState(() => _config = _config.copyWith(galleryIconPath: v))),
        _buildSvgField("Collage", _config.collageIcon(width: 40, height: 40), _config.collageIconPath,
            (v) => setState(() => _config = _config.copyWith(collageIconPath: v))),
        _buildSvgField("Back", _config.backIcon(width: 40, height: 40), _config.backIconPath,
            (v) => setState(() => _config = _config.copyWith(backIconPath: v))),
        _buildSvgField("Print", _config.printIcon(width: 40, height: 40), _config.printIconPath,
            (v) => setState(() => _config = _config.copyWith(printIconPath: v))),
        _buildSvgField("Remove", _config.removeIcon(width: 40, height: 40), _config.removeIconPath,
            (v) => setState(() => _config = _config.copyWith(removeIconPath: v))),
        _buildSvgField("Close", _config.closeIcon(width: 40, height: 40), _config.closeIconPath,
            (v) => setState(() => _config = _config.copyWith(closeIconPath: v))),
        _buildSvgField("Previous", _config.prevIcon(width: 40, height: 40), _config.prevIconPath,
            (v) => setState(() => _config = _config.copyWith(prevIconPath: v))),
        _buildSvgField("Next", _config.nextIcon(width: 40, height: 40), _config.nextIconPath,
            (v) => setState(() => _config = _config.copyWith(nextIconPath: v))),
      ],
    );
  }

  /// Onglet Texts
  Widget _buildTextsTab() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        _buildFontFamilyField("Font family", _config.fontFamilyName,
            (v) => setState(() => _config = _config.copyWith(fontFamilyName: v))),
        _buildColorField("Text color", _config.textColor, _config.textColorHex,
            (v) => setState(() => _config = _config.copyWith(textColorHex: v))),
        _buildTextField("Capture text", _config.captureText,
            (v) => setState(() => _config = _config.copyWith(captureText: v))),
      ],
    );
  }

  /// Onglet Shortcuts
  Widget _buildShortcutsTab() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        _buildShortcutField("Open Settings", _config.shortcutSettingsLogicalKeyId,
            (v) => setState(() => _config = _config.copyWith(shortcutSettingsLogicalKeyId: v))),
        _buildShortcutField("Previous", _config.shortcutPrevLogicalKeyId,
            (v) => setState(() => _config = _config.copyWith(shortcutPrevLogicalKeyId: v))),
        _buildShortcutField("Next", _config.shortcutNextLogicalKeyId,
            (v) => setState(() => _config = _config.copyWith(shortcutNextLogicalKeyId: v))),
        _buildShortcutField("Enter", _config.shortcutEnterLogicalKeyId,
            (v) => setState(() => _config = _config.copyWith(shortcutEnterLogicalKeyId: v))),
      ],
    );
  }
}
