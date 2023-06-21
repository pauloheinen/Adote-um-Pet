import 'package:flutter/material.dart';

class NavigatorUtil {
  static pushTo(BuildContext context, Widget pane) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => pane));
  }

  static pushAndRemoveTo(BuildContext context, Widget pane) {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => pane,
      ),
      (route) => false,
    );
  }
}
