import 'package:flutter/material.dart';

class CustomOutlineBorder {
  static buildCustomBorder() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.elliptical(10.0, 10.0),
      ),
      borderSide: BorderSide(color: Colors.black38, width: 2),
    );
  }
}
