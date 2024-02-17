import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropdownCustomButton extends StatefulWidget {
  final String? upperTitle;
  final String dropdownHint;
  final List<String> itemList;
  final Function(String)? onSelect;
  String value = "";

  DropdownCustomButton(
      {super.key,
        this.upperTitle,
        required this.dropdownHint,
        required this.itemList,
        this.onSelect,
        required this.value});

  @override
  State<DropdownCustomButton> createState() => _DropdownCustomButtonState();
}

class _DropdownCustomButtonState extends State<DropdownCustomButton> {
  void click() {
    if (widget.onSelect != null) {
      widget.onSelect?.call(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: widget.upperTitle != null,
          child: Text(
            widget.upperTitle!,
              style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            style: Theme.of(context).textTheme.displaySmall,
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 254, 250, 224),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(
                  Radius.circular(14),
                ),
              ),
            ),
            buttonStyleData: const ButtonStyleData(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 254, 250, 224),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(
                  Radius.circular(14),
                ),
              ),
            ),
            hint: Text(
              widget.dropdownHint,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            value: widget.value.isEmpty ? null : widget.value,
            onChanged: (change) => setState(
                  () {
                widget.value = change.toString();
                click();
              },
            ),
            items: widget.itemList
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
          ),
        ),
      ],
    );
  }
}
