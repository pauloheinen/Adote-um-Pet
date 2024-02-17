import 'package:adote_um_pet/utilities/global.dart';
import 'package:flutter/material.dart';

class Toast {
  static void successToast(BuildContext context, String text) async {
    _buildToast(context, text, Icons.check, Colors.green.shade700);
  }

  static void warningToast(BuildContext context, String text) {
    _buildToast(context, text, Icons.warning, Colors.yellow.shade700);
  }

  static void errorToast(BuildContext context, String text) {
    _buildToast(context, text, Icons.dangerous, Colors.red.shade700);
  }

  static void informToast(BuildContext context, String text) {
    _buildToast(context, text, Icons.info, Colors.blue.shade700);
  }

  static void _buildToast(
      BuildContext context, String text, IconData icon, Color color) {
    snackbarKey.currentState?.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.transparent,
        dismissDirection: DismissDirection.startToEnd,
        elevation: 0,
        padding: EdgeInsets.zero,
        behavior: SnackBarBehavior.fixed,
        content: Container(
          margin: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Icon(
                  icon,
                  size: 30,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.black,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black87,
                  size: 30,
                ),
                onPressed: () {
                  snackbarKey.currentState?.hideCurrentSnackBar(
                    reason: SnackBarClosedReason.dismiss,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
