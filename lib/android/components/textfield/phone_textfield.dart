import 'package:adote_um_pet/android/components/border/outline_input_border/outline_border.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomPhoneTextField extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final MaskTextInputFormatter phoneMask = MaskTextInputFormatter(
      mask: "(##) # ####-####",
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  final bool readOnly;

  CustomPhoneTextField({
    Key? key,
    this.readOnly = false,
  }) : super(key: key);

  bool isPhoneNumberValid() {
    return phoneMask.isFill();
  }

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
          } else if (!isPhoneNumberValid()) {
            return 'Número de telefone inválido';
          }
          return null;
        },
        controller: controller,
        readOnly: readOnly,
        keyboardType: TextInputType.phone,
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
