import 'package:flutter/material.dart';

import '../Border/OutlineInputBorder/outline_border.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  bool readOnly;
  bool visible = true;
  InputBorder? border;
  final Function(String)? onChanged;

  CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.visible = true,
    this.border,
    this.onChanged,
  });

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<CustomTextField> {
  void click() {
    if (widget.onChanged != null) {
      widget.onChanged?.call(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: widget.controller,
        readOnly: widget.readOnly,
        keyboardType: TextInputType.multiline,
        enabled: widget.visible,
        onChanged: (change) => setState(() {
          click();
        }),
        decoration: InputDecoration(
            enabledBorder:
            widget.border ?? CustomOutlineBorder.buildCustomBorder(),
            focusedBorder:
            widget.border ?? CustomOutlineBorder.buildCustomBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            label: Text(widget.label,
                style: const TextStyle(color: Colors.black87, fontSize: 16),
                softWrap: true,
                overflow: TextOverflow.ellipsis)));
  }
}
