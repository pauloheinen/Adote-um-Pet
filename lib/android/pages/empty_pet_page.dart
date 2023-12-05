import 'package:adote_um_pet/android/controller/city_picker_controller.dart';
import 'package:flutter/material.dart';

import '../components/Picker/city_picker.dart';

class EmptyPetPage extends StatefulWidget {
  final CityPickerController controller = CityPickerController();
  final VoidCallback? selectCityCallback;
  final VoidCallback? addPetCallback;

  EmptyPetPage({
    Key? key,
    this.selectCityCallback,
    this.addPetCallback,
  }) : super(key: key);

  @override
  State<EmptyPetPage> createState() => _EmptyPetPageState();
}

class _EmptyPetPageState extends State<EmptyPetPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomCityPicker(
              cityFilterController: widget.controller.cityFilterController,
              city: widget.controller.selectedCity,
              state: widget.controller.selectedState,
              onSelectCity: widget.selectCityCallback,
            ),
            IconButton(
                onPressed: widget.addPetCallback, icon: const Icon(Icons.add)),
          ],
        ),
        const Center(child: Text("Nenhum Pet disponível")),
      ],
    );
  }
}
