import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:file_picker/file_picker.dart';

Future<void> pickFile(void Function(String) onSelected, {List<String>? allowedExtensions}) async {
  final result = await FilePicker.platform.pickFiles(
    type: allowedExtensions == null ? FileType.any : FileType.custom,
    allowedExtensions: allowedExtensions,
  );
  if (result != null && result.files.single.path != null) {
    onSelected(result.files.single.path!);
  }
}

Future<void> pickDirectory(void Function(String) onSelected) async {
  final result = await FilePicker.platform.getDirectoryPath();
  if (result != null) {
    onSelected(result);
  }
}

Widget buildTextField(String label, String value, ValueChanged<String> onChanged, {bool obscure = false}) {
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

Widget buildPasswordField({
  required TextEditingController controller,
  required bool hasPassword,
  required VoidCallback onModified,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    child: TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Admin panel password",
        border: const OutlineInputBorder(),
        helperText: hasPassword
            ? "Clear the field and save to remove the password"
            : null,
      ),
      onChanged: (_) => onModified(),
    ),
  );
}

Widget buildFontFamilyField(
  String label,
  String value,
  ValueChanged<String> onChanged,
  List<String> fonts,
) {
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

Widget buildDirectoryField(String label, String? path, ValueChanged<String> onChanged) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: TextFormField(
            key: ValueKey(path),
            readOnly: true,
            initialValue: path,
            decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.folder_open),
          onPressed: () => pickDirectory(onChanged),
        ),
      ],
    ),
  );
}

Widget buildColorField(
  BuildContext context,
  String label,
  Color color,
  String value,
  ValueChanged<String> onChanged,
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: TextFormField(
            key: ValueKey(value),
            initialValue: value,
            decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () async {
            var pickedColor = color;
            final picked = await showDialog<Color>(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("Pick a color for $label"),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: color,
                    onColorChanged: (c) => pickedColor = c,
                  ),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                  TextButton(onPressed: () => Navigator.pop(context, pickedColor), child: const Text("Select")),
                ],
              ),
            );
            if (picked != null) {
              final hex = picked.toARGB32().toRadixString(16).toUpperCase();
              onChanged(hex);
            }
          },
          child: Container(width: 32, height: 32, color: color),
        ),
      ],
    ),
  );
}

Widget buildImageField(
  String label,
  Widget image,
  String? path,
  ValueChanged<String> onChanged,
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        image,
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            key: ValueKey(path),
            readOnly: true,
            initialValue: path,
            decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.folder_open),
          onPressed: () => pickFile(onChanged, allowedExtensions: ["png", "jpg", "jpeg"]),
        ),
      ],
    ),
  );
}

Widget buildSvgField(
  String label,
  Widget svg,
  String? path,
  ValueChanged<String> onChanged,
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        svg,
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            key: ValueKey(path),
            readOnly: true,
            initialValue: path,
            decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.folder_open),
          onPressed: () => pickFile(onChanged, allowedExtensions: ["svg"]),
        ),
      ],
    ),
  );
}

Widget buildShortcutField(String label, int keyId, ValueChanged<int> onChanged) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    child: Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          onChanged(event.logicalKey.keyId);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: TextFormField(
        key: ValueKey(keyId),
        initialValue: LogicalKeyboardKey(keyId).keyLabel,
        readOnly: true,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    ),
  );
}
