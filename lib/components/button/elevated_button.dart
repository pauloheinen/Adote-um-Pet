import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final double buttonSize;
  final Function()? onClick;

  const CustomElevatedButton({
    super.key,
    required this.label,
    required this.buttonSize,
    this.onClick,
  });

  void click() {
    if (onClick != null) {
      onClick?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: SizedBox(
        width: buttonSize,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 60, 253, 53),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            onPressed: () => click()),
      ),
    );
  }
}

enum ButtonSize {
  minSize,
  midSize,
  largeSize,
}

extension ButtonSizeExtension on ButtonSize {
  double get size {
    switch (this) {
      case ButtonSize.minSize:
        return 100;
      case ButtonSize.midSize:
        return 150;
      case ButtonSize.largeSize:
        return 200;
      default:
        throw Exception("Unknown button size");
    }
  }
}
