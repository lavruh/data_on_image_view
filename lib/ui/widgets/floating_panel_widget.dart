import 'package:flutter/material.dart';

class FloatingPanelWidget extends StatefulWidget {
  const FloatingPanelWidget(
      {Key? key, required this.children, this.initPosition})
      : super(key: key);
  final List<Widget> children;
  final Offset? initPosition;

  @override
  State<FloatingPanelWidget> createState() => _FloatingPanelWidgetState();
}

class _FloatingPanelWidgetState extends State<FloatingPanelWidget> {
  double x = 0;
  double y = 0;

  @override
  void initState() {
    final pos = widget.initPosition;
    if (pos != null) {
      x = pos.dx;
      y = pos.dy;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final child = Card(
      color: Colors.white24,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: 5,
              height: 25,
              color: Colors.grey,
            ),
          ),
          ...widget.children
        ],
      ),
    );

    return Positioned(
      top: y,
      left: x,
      child: Draggable(
        onDragEnd: (details) {
          final pos = details.offset;
          x = pos.dx;
          y = pos.dy;
          setState(() {});
        },
        feedback: child,
        child: child,
      ),
    );
  }
}
