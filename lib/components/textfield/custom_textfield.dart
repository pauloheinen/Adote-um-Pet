import 'package:adote_um_pet/logic/cubit/textfield/textfield_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomTextfield extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final bool visible;
  final Function(String)? onChanged;
  final bool obscure;
  final TextInputType textInputType;
  final bool shouldValidate;

  const CustomTextfield({
    Key? key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.visible = true,
    this.onChanged,
    this.obscure = false,
    required this.textInputType,
    this.shouldValidate = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextfieldCubit, TextfieldStates>(
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: textInputType,
          enabled: visible,
          obscureText: obscure,
          onChanged: (change) {
            context.read<TextfieldCubit>().updateText(change);
            if (onChanged != null) {
              onChanged?.call(change);
            }
          },
          validator: (value) {
            if (shouldValidate && (value == null || value.isEmpty)) {
              return 'O campo deve ser preenchido!';
            }
            return null;
          },
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
              label,
              style: Theme.of(context).textTheme.displaySmall,
              softWrap: true,
            ),
          ),
        );
      },
    );
  }
}
