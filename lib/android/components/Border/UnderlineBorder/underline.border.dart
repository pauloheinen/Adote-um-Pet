import 'package:flutter/material.dart';

class CustomUnderlineBorder {
  static buildCustomBorder() {
    return const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black38, width: 2),
    );
  }
}