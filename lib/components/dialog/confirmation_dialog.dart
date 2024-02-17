import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.displayMedium),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28.0)),
      ),
      contentPadding:
      const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
      content: Text(
        message,
        style: Theme.of(context).textTheme.displaySmall,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            onCancel();
          },
          child: const Text('Não'),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
          },
          child: Text(
            'Sim',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}
