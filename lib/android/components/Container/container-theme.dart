import 'package:flutter/material.dart';

class ContainerCustomWidget extends StatefulWidget {
  final BuildContext context;
  final Widget child;

  const ContainerCustomWidget({
    super.key,
    required this.context,
    required this.child,
  });

  @override
  State<ContainerCustomWidget> createState() => _ContainerCustomWidgetState();
}

class _ContainerCustomWidgetState extends State<ContainerCustomWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.green,
            Colors.yellow,
          ],
        )),
        height: MediaQuery.of(widget.context).size.height -
            MediaQuery.of(widget.context).viewInsets.bottom,
        child: Center(child: widget.child));
  }
}
