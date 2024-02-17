import 'package:adote_um_pet/utilities/file_util.dart';
import 'package:flutter/material.dart';

class EmptyStatePane extends StatelessWidget {

  final String description;

  const EmptyStatePane({required this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FileUtil.getImage("pet-finding.png"),
          const SizedBox(height: 16.0),
          const Text(
            'Nada para exibir',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
