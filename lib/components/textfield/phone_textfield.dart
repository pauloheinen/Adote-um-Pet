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
        style: Theme.of(context).textTheme.displaySmall,
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
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(218, 68, 234, 148),
              width: 2.0,
            ),
          ),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(218, 68, 234, 148),
              width: 2.0,
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(218, 68, 234, 148),
              width: 2.0,
            ),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
          label: Text(
            "Telefone",
            style: Theme.of(context).textTheme.displaySmall,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
