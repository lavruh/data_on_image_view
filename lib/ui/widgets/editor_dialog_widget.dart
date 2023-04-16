import 'package:data_on_image_view/domain/view_port.dart';
import 'package:data_on_image_view/ui/widgets/color_pick_button_widget.dart';
import 'package:flutter/material.dart';

class EditorDialogWidget extends StatefulWidget {
  const EditorDialogWidget({Key? key, required this.item}) : super(key: key);
  final ViewPort item;

  @override
  State<EditorDialogWidget> createState() => _EditorDialogWidgetState();
}

class _EditorDialogWidgetState extends State<EditorDialogWidget> {
  final formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final titleController = TextEditingController();
  late Color backgroundColor;
  late Color titleColor;
  late Color textColor;

  @override
  void initState() {
    idController.text = widget.item.id;
    titleController.text = widget.item.title;
    backgroundColor = widget.item.backgroundColor;
    titleColor = widget.item.titleColor;
    textColor = widget.item.textColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: idController,
              decoration: const InputDecoration(labelText: 'Id'),
              validator: _textValidator,
            ),
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: _textValidator,
            ),
            ColorPickButtonWidget(
                title: 'Background',
                color: backgroundColor,
                onAccept: (c) {
                  backgroundColor = c;
                  setState(() {});
                }),
            ColorPickButtonWidget(
                title: 'Title',
                color: titleColor,
                onAccept: (c) {
                  titleColor = c;
                  setState(() {});
                }),
            ColorPickButtonWidget(
                title: 'Text',
                color: textColor,
                onAccept: (c) {
                  textColor = c;
                  setState(() {});
                }),
          ],
        ),
      ),
      actions: [
        IconButton(onPressed: _confirm, icon: const Icon(Icons.check)),
      ],
    );
  }

  void _confirm() {
    if(formKey.currentState!.validate()) {
      Navigator.of(context).pop(widget.item.copyWith(
      id: idController.text,
      title: titleController.text,
      backgroundColor: backgroundColor,
      titleColor: titleColor,
      textColor: textColor,
    ));
    }
  }

  String? _textValidator(String? s){
    if(s!=null){
      if (s.isEmpty) {
        return 'Should not be empty';
      }
    } else {
      return 'No valid data';
    }
    return null;
  }
}
