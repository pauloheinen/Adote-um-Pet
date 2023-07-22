import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

// pub.dev/packages/motion_toast/versions/2.6.5
// https://codesinsider.com/flutter-styled-motion-toast-example-tutorial/
class Toast {
  static void confirmToast(BuildContext context, String text) async {
    _buildGeneric(context, text, Icons.check, Colors.green);
  }

  static void warningToast(BuildContext context, String text) {
    _buildGeneric(context, text, Icons.warning, Colors.yellow);
  }

  static void errorToast(BuildContext context, String text) {
    _buildGeneric(context, text, Icons.dangerous, Colors.red);
  }

  static void informToast(BuildContext context, String text) {
    _buildGeneric(context, text, Icons.info, Colors.grey);
  }

  static void _buildGeneric(BuildContext context, String text, IconData icon, MaterialColor color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        margin: const EdgeInsets.all(12),
        padding: EdgeInsets.zero,
        behavior: SnackBarBehavior.floating,
        content: Container(child: Text(text)),
      ),
    );
     // MotionToast(
     //    primaryColor: color,
     //    description: Text(text),
     //    icon: icon,
     //    animationDuration: const Duration(seconds: 5),
     //    position: MotionToastPosition.top,
     //    animationType: AnimationType.fromTop)
     //    .show(context);
  }
}
