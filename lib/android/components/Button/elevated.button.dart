import 'package:flutter/material.dart';

class ElevatedButtonCustomWidget extends StatefulWidget {
  final String label;
  final double? labelSize;
  final Function() callback;

  const ElevatedButtonCustomWidget(
      this.callback, {
    super.key,
    required this.label,
    this.labelSize,
  });

  @override
  State<ElevatedButtonCustomWidget> createState() =>
      _ElevatedButtonCustomWidgetState();
}

class _ElevatedButtonCustomWidgetState
    extends State<ElevatedButtonCustomWidget> {
  void click() {
    widget.callback.call();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        backgroundColor: Colors.green,
      ),
      child: Text(
        widget.label,
        style: TextStyle(fontSize: widget.labelSize ?? 20, color: Colors.yellow),
      ),
      onPressed: () {
        click();
      },
    );
  }
}
