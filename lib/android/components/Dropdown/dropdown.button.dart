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
      this.onSelect,required this.value
      });

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
            style: const TextStyle(fontSize: 20),
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
              style: const TextStyle(color: Colors.black, fontSize: 14),
              dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  decoration: BoxDecoration(color: Colors.yellow[300])),
              buttonStyleData: ButtonStyleData(
                  decoration: BoxDecoration(
                color: Colors.yellow[300],
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              )),
              hint: Text(widget.dropdownHint,
                  style: const TextStyle(fontSize: 14, color: Colors.black)),
              value: widget.value.isEmpty ? null : widget.value,
              onChanged: (change) => setState(() {
                    widget.value = change.toString();
                    click();
                  }),
              items: widget.itemList
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList()),
        ),
      ],
    );
  }
}
