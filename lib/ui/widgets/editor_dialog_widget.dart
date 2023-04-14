import 'package:data_on_image_view/domain/view_port.dart';
import 'package:flutter/material.dart';

class EditorDialogWidget extends StatefulWidget {
  const EditorDialogWidget({Key? key, required this.item}) : super(key: key);
  final ViewPort item;

  @override
  State<EditorDialogWidget> createState() => _EditorDialogWidgetState();
}

class _EditorDialogWidgetState extends State<EditorDialogWidget> {
  final idController = TextEditingController();
  final titleController = TextEditingController();

  @override
  void initState() {
    idController.text = widget.item.id;
    titleController.text = widget.item.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: idController,
              decoration: const InputDecoration(labelText: 'Id'),
            ),
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(onPressed: _confirm, icon: const Icon(Icons.check)),
      ],
    );
  }

  void _confirm() {
    Navigator.of(context).pop(widget.item.copyWith(
      id: idController.text,
      title: titleController.text,
    ));
  }

}
