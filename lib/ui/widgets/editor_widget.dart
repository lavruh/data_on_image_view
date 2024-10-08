import 'package:data_on_image_view/ui/widgets/question_dialog_widget.dart';
import 'package:flutter/material.dart';

class EditorWidget extends StatelessWidget {
  const EditorWidget(
      {super.key,
      required this.child,
      required this.isSet,
      required this.isChanged,
      required this.save});

  final Widget child;
  final bool isSet;
  final bool isChanged;
  final Function save;

  @override
  Widget build(BuildContext context) {
    if (!isSet) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return NavigatorPopHandler(
      onPop: () async {
        final n = Navigator.of(context);
        final pop = await _hasToSaveDialog(context);
        if (pop == true) n.pop();
      },
      child: SizedBox(
        height: 600,
        width: 700,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(child: child),
              if (isChanged)
                TextButton(onPressed: () => save(), child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _hasToSaveDialog(BuildContext context) async {
    bool? actFl = false;
    if (isSet && isChanged) {
      actFl = await questionDialogWidget(
          question: 'Save changes?', context: context);
    }
    if (actFl == null) {
      return false;
    }
    if (actFl) {
      save();
    }
    return true;
  }
}
