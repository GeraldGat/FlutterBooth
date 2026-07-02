import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutterbooth/models/config/app_config.dart';
import 'package:flutterbooth/models/config/extensions/app_config_colors.dart';
import 'package:flutterbooth/models/config/extensions/app_config_icon_widgets.dart';
import 'package:flutterbooth/models/config/extensions/app_config_image_widgets.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentIndex = 0;
  AppConfig? _config;

  Future<void> _pickFile(Function(String) onSelected, {List<String>? allowedExtensions}) async {
    final result = await FilePicker.platform.pickFiles(
      type: allowedExtensions == null ? FileType.any : FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    if (result != null && result.files.single.path != null) {
      onSelected(result.files.single.path!);
    }
  }
  
  Future<void> _pickDirectory(Function(String) onSelected) async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      onSelected(result);
    }
  }

  Future<void> _saveConfig() async {
    final config = _config!;
    final toSave = config.copyWith(
      settings: config.settings.copyWith(
        adminPassword: config.settings.adminPassword?.isEmpty ?? true
          ? ""
          : sha256.convert(utf8.encode(config.settings.adminPassword ?? "")).toString(),
      )
    );

    await ref.read(configProvider.notifier).save(toSave);
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

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

  Widget _buildFontFamilyField(String label, String value, Function(String) onChanged, List<String> fonts) {
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

  Widget _buildDirectoryField(String label, String? path, Function(String) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: TextEditingController(text: path),
              decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: () => _pickDirectory(onChanged),
          ),
        ],
      ),
    );
  }

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
                final hex = picked.toARGB32().toRadixString(16).toUpperCase();
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
  final asyncConfig = ref.watch(configProvider);

  return asyncConfig.when(
    data: (config) {
      _config ??= config;
      final tabs = ["Settings", "Wallpapers", "Icons", "Texts", "Shortcuts"];
      final fonts = GoogleFonts.asMap().keys.toList()..sort();

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
                _buildTextsTab(fonts),
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
    },
    loading: () => const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    ),
    error: (error, _) => Scaffold(
      body: Center(child: Text('Error loading config: $error')),
    ),
  );
}


  Widget _buildSettingsTab() {
    final config = _config!;
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        _buildDirectoryField(
          "File save path",
          config.settings.fileSavePath,
          (v) => setState(() => _config = _config!.copyWith(settings: _config!.settings.copyWith(fileSavePath: v))),
        ),
        _buildImageField(
          "Event Logo",
          config.eventLogo(width: 80, height: 80),
          config.settings.eventLogoPath,
          (v) => setState(() => _config = _config!.copyWith(settings: _config!.settings.copyWith(eventLogoPath: v))),
        ),
        _buildTextField(
          "Home text",
          config.settings.homeText,
          (v) => setState(() => _config = _config!.copyWith(settings: _config!.settings.copyWith(homeText: v))),
        ),  
        _buildColorField(
          "Main color",
          config.mainColor,
          config.settings.mainColorHex,
          (v) => setState(() => _config = _config!.copyWith(settings: _config!.settings.copyWith(mainColorHex: v))),
        ),
        _buildColorField(
          "Accent color",
          config.accentColor,
          config.settings.accentColorHex,
          (v) => setState(() => _config = _config!.copyWith(settings: _config!.settings.copyWith(accentColorHex: v))),
        ),
        _buildTextField(
          "Admin panel password",
          "",
          (v) => setState(() => _config = _config!.copyWith(settings: _config!.settings.copyWith(adminPassword: v))),
          obscure: true
        ),
        _buildTextField(
          "Gphoto2 port",
          config.settings.gphotoPort ?? "",
          (v) => setState(() => _config = _config!.copyWith(settings: _config!.settings.copyWith(gphotoPort: v))),
        ),
      ],
    );
  }

  Widget _buildWallpapersTab() {
    final config = _config!;
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        _buildImageField(
          "Main wallpaper",
          config.mainWallpaper(width: 80, height: 80),
          config.wallpaper.mainWallpaperPath,
          (v) => setState(() => _config = _config!.copyWith(wallpaper: _config!.wallpaper.copyWith(mainWallpaperPath: v))),
        ),
        _buildImageField(
          "Countdown 3",
          config.countdown3(width: 80, height: 80),
          config.wallpaper.countdown3Path,
          (v) => setState(() => _config = _config!.copyWith(wallpaper: _config!.wallpaper.copyWith(countdown3Path: v))),
        ),
        _buildImageField(
          "Countdown 2",
          config.countdown2(width: 80, height: 80),
          config.wallpaper.countdown2Path,
          (v) => setState(() => _config = _config!.copyWith(wallpaper: _config!.wallpaper.copyWith(countdown2Path: v))),
        ),
        _buildImageField(
          "Countdown 1",
          config.countdown1(width: 80, height: 80),
          config.wallpaper.countdown1Path,
          (v) => setState(() => _config = _config!.copyWith(wallpaper: _config!.wallpaper.copyWith(countdown1Path: v))),
        ),
        _buildImageField(
          "Capture",
          config.capture(width: 80, height: 80),
          config.wallpaper.capturePath,
          (v) => setState(() => _config = _config!.copyWith(wallpaper: _config!.wallpaper.copyWith(capturePath: v))),
        ),
        _buildImageField("Result",
        config.result(width: 80, height: 80),
        config.wallpaper.resultPath,
          (v) => setState(() => _config = _config!.copyWith(wallpaper: _config!.wallpaper.copyWith(resultPath: v))),
        ),
        _buildImageField("Gallery",
        config.gallery(width: 80, height: 80),
        config.wallpaper.galleryPath,
          (v) => setState(() => _config = _config!.copyWith(wallpaper: _config!.wallpaper.copyWith(galleryPath: v))),
        ),
        _buildImageField("Collage",
        config.collage(width: 80, height: 80),
        config.wallpaper.collagePath,
          (v) => setState(() => _config = _config!.copyWith(wallpaper: _config!.wallpaper.copyWith(collagePath: v))),
        ),
      ],
    );
  }

  Widget _buildIconsTab() {
    final config = _config!;
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        _buildSvgField(
          "Photo",
          config.photoIcon(width: 40, height: 40),
          config.icons.photoIconPath,
          (v) => setState(() => _config = _config!.copyWith(icons: _config!.icons.copyWith(photoIconPath: v))),
        ),
        _buildSvgField(
          "Gallery",
          config.galleryIcon(width: 40, height: 40),
          config.icons.galleryIconPath,
          (v) => setState(() => _config = _config!.copyWith(icons: _config!.icons.copyWith(galleryIconPath: v))),
        ),
        _buildSvgField(
          "Collage",
          config.collageIcon(width: 40, height: 40),
          config.icons.collageIconPath,
          (v) => setState(() => _config = _config!.copyWith(icons: _config!.icons.copyWith(collageIconPath: v))),
        ),
        _buildSvgField(
          "Back",
          config.backIcon(width: 40, height: 40),
          config.icons.backIconPath,
          (v) => setState(() => _config = _config!.copyWith(icons: _config!.icons.copyWith(backIconPath: v))),
        ),
        _buildSvgField(
          "Print",
          config.printIcon(width: 40, height: 40),
          config.icons.printIconPath,
          (v) => setState(() => _config = _config!.copyWith(icons: _config!.icons.copyWith(printIconPath: v))),
        ),
        _buildSvgField(
          "Remove",
          config.removeIcon(width: 40, height: 40),
          config.icons.removeIconPath,
          (v) => setState(() => _config = _config!.copyWith(icons: _config!.icons.copyWith(removeIconPath: v))),
        ),
        _buildSvgField(
          "Close",
          config.closeIcon(width: 40, height: 40),
          config.icons.closeIconPath,
          (v) => setState(() => _config = _config!.copyWith(icons: _config!.icons.copyWith(closeIconPath: v))),
        ),
        _buildSvgField(
          "Previous",
          config.prevIcon(width: 40, height: 40),
          config.icons.prevIconPath,
          (v) => setState(() => _config = _config!.copyWith(icons: _config!.icons.copyWith(prevIconPath: v))),
        ),
        _buildSvgField(
          "Next",
          config.nextIcon(width: 40, height: 40),
          config.icons.nextIconPath,
          (v) => setState(() => _config = _config!.copyWith(icons: _config!.icons.copyWith(nextIconPath: v))),
        ),
      ],
    );
  }

  Widget _buildTextsTab(List<String> fonts) {
    final config = _config!;
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        _buildFontFamilyField(
          "Font family",
          config.texts.fontFamilyName,
          (v) => setState(() => _config = _config!.copyWith(texts: _config!.texts.copyWith(fontFamilyName: v))),
          fonts,
        ),
        _buildColorField(
          "Text color",
          config.textColor,
          config.texts.textColorHex,
          (v) => setState(() => _config = _config!.copyWith(texts: _config!.texts.copyWith(textColorHex: v))),
        ),
        _buildTextField(
          "Capture text",
          config.texts.captureText,
          (v) => setState(() => _config = _config!.copyWith(texts: _config!.texts.copyWith(captureText: v))),
        ),
      ],
    );
  }

  Widget _buildShortcutsTab() {
    final config = _config!;
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        _buildShortcutField(
          "Open Settings",
          config.shortcuts.settings,
          (v) => setState(() => _config = _config!.copyWith(shortcuts: _config!.shortcuts.copyWith(settings: v))),
        ),
        _buildShortcutField(
          "Previous",
          config.shortcuts.prev,
          (v) => setState(() => _config = _config!.copyWith(shortcuts: _config!.shortcuts.copyWith(prev: v))),
        ),
        _buildShortcutField(
          "Next",
          config.shortcuts.next,
          (v) => setState(() => _config = _config!.copyWith(shortcuts: _config!.shortcuts.copyWith(next: v))),
        ),
        _buildShortcutField(
          "Enter",
          config.shortcuts.enter,
          (v) => setState(() => _config = _config!.copyWith(shortcuts: _config!.shortcuts.copyWith(enter: v))),
        ),
      ],
    );
  }
}
