import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../Border/OutlineInputBorder/outline_border.dart';

class CustomPhoneTextField extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final MaskTextInputFormatter phoneMask = MaskTextInputFormatter(
      mask: "(##) # ####-####",
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  bool readOnly;

  CustomPhoneTextField({
    this.readOnly = false,
  });

  String getUnmaskedText() {
    return phoneMask.getUnmaskedText();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
      child: TextFormField(
        style: const TextStyle(color: Colors.black87),
        validator: (value) {
          if (value == null || value.isEmpty || controller.text.isEmpty) {
            return 'O campo deve ser preenchido!';
          }
          return null;
        },
        controller: controller,
        readOnly: readOnly,
        keyboardType: TextInputType.multiline,
        inputFormatters: [phoneMask],
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: CustomOutlineBorder.buildCustomBorder(),
          focusedBorder: CustomOutlineBorder.buildCustomBorder(),
          focusedErrorBorder: CustomOutlineBorder.buildCustomBorder(),
          errorBorder: CustomOutlineBorder.buildCustomBorder(),
          errorStyle: const TextStyle(color: Colors.black87),
          label: const Text(
            "Telefone",
            style: TextStyle(color: Colors.black87, fontSize: 16),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class TextFieldState {
  TextEditingController controller;
  MaskTextInputFormatter phoneMask;
  bool readOnly;

  TextFieldState({
    required this.controller,
    required this.phoneMask,
    required this.readOnly,
  });

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: TextFormField(
        style: const TextStyle(color: Colors.black87),
        validator: (value) {
          if (value == null || value.isEmpty || controller.text.isEmpty) {
            return 'O campo deve ser preenchido!';
          }
          return null;
        },
        controller: controller,
        readOnly: readOnly,
        keyboardType: TextInputType.phone,
        inputFormatters: [phoneMask],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: CustomOutlineBorder.buildCustomBorder(),
          focusedBorder: CustomOutlineBorder.buildCustomBorder(),
          focusedErrorBorder: CustomOutlineBorder.buildCustomBorder(),
          errorBorder: CustomOutlineBorder.buildCustomBorder(),
          errorStyle: const TextStyle(color: Colors.black87),
          label: const Text(
            "Telefone",
            style: TextStyle(color: Colors.black87, fontSize: 20),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  getUnmaskedText() {
    return phoneMask.getUnmaskedText();
  }
}
