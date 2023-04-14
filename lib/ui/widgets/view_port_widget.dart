import 'package:data_on_image_view/domain/view_port.dart';
import 'package:flutter/material.dart';

class ViewPortWidget extends StatefulWidget {
  const ViewPortWidget({Key? key, required this.item, this.data})
      : super(key: key);
  final ViewPort item;
  final Map<String, String>? data;
  @override
  State<ViewPortWidget> createState() => _ViewPortWidgetState();
}

class _ViewPortWidgetState extends State<ViewPortWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.item.y,
      left: widget.item.x,
      child: Card(
        color: widget.item.backgroundColor,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: widget.item.titleColor)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color:  widget.item.titleColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              ..._getDataWidgets(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getDataWidgets() {
    List<Widget> w = [];
    if (widget.data != null) {
      for (final e in widget.data!.entries) {
        w.add(Text(
          '${e.key} :  ${e.value}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:  widget.item.textColor,
              ),
        ));
      }
    }
    return w;
  }
}
