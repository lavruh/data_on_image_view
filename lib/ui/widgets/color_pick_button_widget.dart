import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickButtonWidget extends StatelessWidget {
  const ColorPickButtonWidget(
      {Key? key,
      required this.color,
      required this.onAccept,
      required this.title})
      : super(key: key);
  final String title;
  final Color color;
  final void Function(Color c) onAccept;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Card(
          elevation: 3,
          child: ListTile(
            leading: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            title: Text(title),
            onTap: () => _pickColor(context),
          ),
        ));
  }

  _pickColor(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: SizedBox(
              height: 200,
              child: ColorPicker(
                  pickerColor: color,
                  colorPickerWidth: 200,
                  hexInputBar: true,
                  paletteType: PaletteType.hueWheel,
                  onColorChanged: (c) {
                    onAccept(c);
                  }),
            ),
          );
        });
  }
}
