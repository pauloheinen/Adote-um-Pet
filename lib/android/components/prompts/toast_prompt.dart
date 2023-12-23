import 'package:flutter/material.dart';

import '../../utilities/global.dart';

class Toast {
  static void confirmToast(BuildContext context, String text) async {
    _buildGeneric(context, text, Icons.check, Colors.green.shade700);
  }

  static void warningToast(BuildContext context, String text) {
    _buildGeneric(context, text, Icons.warning, Colors.yellow.shade700);
  }

  static void errorToast(BuildContext context, String text) {
    _buildGeneric(context, text, Icons.dangerous, Colors.red.shade700);
  }

  static void informToast(BuildContext context, String text) {
    _buildGeneric(context, text, Icons.info, Colors.blue.shade700);
  }

  static void _buildGeneric(
      BuildContext context, String text, IconData icon, Color color) {
    snackbarKey.currentState?.showSnackBar(SnackBar(
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.transparent,
      showCloseIcon: true,
      dismissDirection: DismissDirection.startToEnd,
      elevation: 0,
      padding: EdgeInsets.zero,
      behavior: SnackBarBehavior.fixed,
      content: IgnorePointer(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 80,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 30,
                ),
                const SizedBox(width: 20),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        // Tamanho de fonte baseado na largura da tela
                        color: Colors.black,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
