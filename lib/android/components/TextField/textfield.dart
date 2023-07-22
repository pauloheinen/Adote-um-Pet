import 'package:flutter/material.dart';

import '../Border/OutlineInputBorder/outline.border.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  bool readOnly;
  bool visible = true;

  CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.visible = true,
  });

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
        child: TextField(
            controller: widget.controller,
            readOnly: widget.readOnly,
            keyboardType: TextInputType.multiline,
            enabled: widget.visible,
            decoration: InputDecoration(
                enabledBorder: CustomOutlineBorder.buildCustomBorder(),
                focusedBorder: CustomOutlineBorder.buildCustomBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                label: Text(widget.label,
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis))));
  }
}
