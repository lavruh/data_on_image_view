import 'package:data_on_image_view/domain/view_port.dart';
import 'package:data_on_image_view/ui/widgets/color_pick_button_widget.dart';
import 'package:flutter/material.dart';

class EditorDialogWidget extends StatefulWidget {
  const EditorDialogWidget(
      {Key? key, required this.item, this.onDelete, this.onDuplicate})
      : super(key: key);
  final ViewPort item;
  final Function? onDelete;
  final Function? onDuplicate;

  @override
  State<EditorDialogWidget> createState() => _EditorDialogWidgetState();
}

class _EditorDialogWidgetState extends State<EditorDialogWidget> {
  final formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final titleController = TextEditingController();
  final titleSizeController = TextEditingController();
  final textSizeController = TextEditingController();
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
    titleSizeController.text = widget.item.titleSize.toString();
    textSizeController.text = widget.item.textSize.toString();
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
            TextFormField(
              controller: titleSizeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Title size'),
              validator: _numberValidator,
            ),
            TextFormField(
              controller: textSizeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Text size'),
              validator: _numberValidator,
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
        if (widget.onDelete != null)
          IconButton(
              onPressed: () => widget.onDelete!(),
              icon: const Icon(Icons.delete_forever)),
        if (widget.onDuplicate != null)
          IconButton(
              onPressed: () => widget.onDuplicate!(),
              icon: const Icon(Icons.control_point_duplicate)),
        IconButton(onPressed: _confirm, icon: const Icon(Icons.check)),
      ],
    );
  }

  void _confirm() {
    if (formKey.currentState!.validate()) {
      Navigator.of(context).pop(widget.item.copyWith(
          id: idController.text,
          title: titleController.text,
          backgroundColor: backgroundColor,
          titleColor: titleColor,
          textColor: textColor,
          titleSize: double.tryParse(titleSizeController.text),
          textSize: double.tryParse(textSizeController.text)));
    }
  }

  String? _textValidator(String? s) {
    if (s != null) {
      if (s.isEmpty) {
        return 'Should not be empty';
      }
    } else {
      return 'No valid data';
    }
    return null;
  }

  String? _numberValidator(String? s) {
    final tmp = _textValidator(s);
    if (tmp == null) {
      try {
        double.parse(s!);
      } on FormatException {
        return 'Should be number';
      }
    }
    return tmp;
  }
}
