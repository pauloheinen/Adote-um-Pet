import 'package:adote_um_pet/android/components/Card/Pet/pet_card.dart';
import 'package:adote_um_pet/android/components/Editor/pet_editor.dart';
import 'package:adote_um_pet/android/components/Loading/loading_box.dart';
import 'package:adote_um_pet/android/components/Picker/city_picker.dart';
import 'package:adote_um_pet/android/components/prompts/toast_prompt.dart';
import 'package:adote_um_pet/android/controllers/city_picker_controller.dart';
import 'package:adote_um_pet/android/entities/user_entity.dart';
import 'package:adote_um_pet/android/helpers/pet_files_wrapper.dart';
import 'package:adote_um_pet/android/preferences/preferences.dart';
import 'package:flutter/material.dart';

import '../entities/pet_entity.dart';
import '../services/pet_service.dart';

class MyPetsPage extends StatefulWidget {
  MyPetsPage({Key? key}) : super(key: key);

  final CityPickerController cityPickerController = CityPickerController();

  @override
  State<MyPetsPage> createState() => _MyPetsPageState();
}

class _MyPetsPageState extends State<MyPetsPage> {
  final List<PetFilesWrapper> wrapper = [];

  bool petsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.yellow[500],
      child: Center(
        child: petsLoaded == false
            ? const CustomLoadingBox()
            : Scaffold(
                backgroundColor: Colors.yellow[500],
                body: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: wrapper.isEmpty
                      ? Column(
                          children: [
                            Row(
                              children: [
                                CustomCityPicker(
                                  cityFilterController: widget
                                      .cityPickerController
                                      .cityFilterController,
                                  city:
                                      widget.cityPickerController.selectedCity,
                                  state:
                                      widget.cityPickerController.selectedState,
                                  onSelectCity: () => _loadPets,
                                ),
                                IconButton(
                                    onPressed: _addPet,
                                    icon: const Icon(Icons.add)),
                              ],
                            ),
                            const Spacer(),
                            const Center(
                                child:
                                    Text("Nenhum Pet disponível para adoção")),
                            const Spacer(
                              flex: 2,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CustomCityPicker(
                                    cityFilterController: widget
                                        .cityPickerController
                                        .cityFilterController,
                                    city: widget
                                        .cityPickerController.selectedCity,
                                    state: widget
                                        .cityPickerController.selectedState,
                                    onSelectCity: () => _loadPets,
                                  ),
                                  IconButton(
                                      onPressed: _addPet,
                                      icon: const Icon(Icons.add)),
                                ]),
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: wrapper.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisExtent: 350,
                                      crossAxisCount: 1,
                                      mainAxisSpacing: 25,
                                    ),
                                    itemBuilder: (context, index) {
                                      return PetCard(
                                        pet: wrapper[index].pet,
                                        files: wrapper[index].files,
                                        editable: true,
                                        callback: () => _loadPets,
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
      ),
    );
  }

  void _loadPets() async {
    wrapper.clear();

    int? ibgeCity = await Preferences.getIbgeCity();

    if (ibgeCity != null) {
      User user = await Preferences.getUserData();

      await PetService().getPetsFilesMapByCityIdAndUser(ibgeCity, user).then(
            (map) => {
              map.forEach(
                (pet, files) {
                  wrapper.add(PetFilesWrapper(pet: pet, files: files));
                },
              ),
            },
          );
    }

    setState(() {
      petsLoaded = true;
    });
  }

  void _addPet() async {
    int? ibgeCity = await Preferences.getIbgeCity();

    if (ibgeCity != null && ibgeCity == 0) {
      Toast.warningToast(context, "Não há cidade selecionada!");
      return;
    }

    User user = await Preferences.getUserData();

    Pet pet = Pet(refOwner: user.id!, refCity: ibgeCity!);

    PetService().addPet(pet).then((value) => {
          pet.id = value,
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PetEditor(
                buildContext: context,
                pet: pet,
                creational: true,
                callback: _loadPets,
              ),
            ),
          )
        });
  }
}
