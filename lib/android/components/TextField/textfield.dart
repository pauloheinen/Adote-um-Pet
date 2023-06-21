import 'package:flutter/material.dart';

class TextFieldCustomWidget extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final InputBorder enabledBorder;
  final InputBorder focusedBorder;
  final bool isLocked;

  const TextFieldCustomWidget({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.isLocked,
  });

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<TextFieldCustomWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 25, 0),
      child: TextField(
        controller: widget.controller,
        readOnly: widget.isLocked,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          enabledBorder: widget.enabledBorder,
          focusedBorder: widget.focusedBorder,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: Text(
            widget.label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
