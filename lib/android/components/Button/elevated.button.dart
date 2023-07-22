import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  final String label;
  final double? labelSize;
  final Function()? onClick;

  const CustomElevatedButton({
    super.key,
    required this.label,
    this.labelSize,
    this.onClick,
  });

  @override
  State<CustomElevatedButton> createState() =>
      _ElevatedButtonCustomWidgetState();
}

class _ElevatedButtonCustomWidgetState extends State<CustomElevatedButton> {
  void click() {
    if (widget.onClick != null) {
      widget.onClick?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          backgroundColor: Colors.green,
        ),
        child: Text(widget.label,
            style: TextStyle(
                fontSize: widget.labelSize ?? 20, color: Colors.yellow)),
        onPressed: () => click());
  }
}
