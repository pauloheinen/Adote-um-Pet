import 'package:flutter/material.dart';

import '../Border/OutlineInputBorder/outline.border.dart';

class TextFieldWithValidationCustomWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool shouldValidate;
  final bool? obscure;

  const TextFieldWithValidationCustomWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.shouldValidate,
    this.obscure,
  });

  @override
  State<TextFieldWithValidationCustomWidget> createState() =>
      _TextFieldWithValidationCustomWidgetState();
}

class _TextFieldWithValidationCustomWidgetState
    extends State<TextFieldWithValidationCustomWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: TextFormField(
        style: const TextStyle(color: Colors.black87),
        validator: (value) {
          if (widget.shouldValidate == true &&
              (value == null ||
                  value.isEmpty ||
                  widget.controller.text.isEmpty)) {
            return 'O campo deve ser preenchido!';
          }
          return null;
        },
        controller: widget.controller,
        keyboardType: TextInputType.multiline,
        obscureText: widget.obscure == null ? false : widget.obscure!,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: OutlineCustomBorder.buildCustomBorder(),
          focusedBorder: OutlineCustomBorder.buildCustomBorder(),
          focusedErrorBorder: OutlineCustomBorder.buildCustomBorder(),
          errorBorder: OutlineCustomBorder.buildCustomBorder(),
          errorStyle: const TextStyle(color: Colors.black87),
          label: Text(
            widget.label,
            style: const TextStyle(color: Colors.black87, fontSize: 20),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
