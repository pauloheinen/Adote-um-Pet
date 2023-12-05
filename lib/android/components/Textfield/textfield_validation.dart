import 'package:adote_um_pet/android/components/Border/OutlineInputBorder/outline_border.dart';
import 'package:flutter/material.dart';

class CustomValidateTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool shouldValidate;
  bool obscure;
  bool readOnly;

  CustomValidateTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.shouldValidate,
    this.obscure = false,
    this.readOnly = false,
  });

  @override
  State<CustomValidateTextField> createState() => _CustomValidateTextField();
}

class _CustomValidateTextField extends State<CustomValidateTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
      readOnly: widget.readOnly,
      keyboardType: TextInputType.multiline,
      obscureText: widget.obscure,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: CustomOutlineBorder.buildCustomBorder(),
        focusedBorder: CustomOutlineBorder.buildCustomBorder(),
        focusedErrorBorder: CustomOutlineBorder.buildCustomBorder(),
        errorBorder: CustomOutlineBorder.buildCustomBorder(),
        errorStyle: const TextStyle(color: Colors.black87),
        label: Text(
          widget.label,
          style: const TextStyle(color: Colors.black87, fontSize: 16),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
