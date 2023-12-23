import 'package:adote_um_pet/android/components/Card/Pet/pet_card.dart';
import 'package:adote_um_pet/android/components/Loading/loading_box.dart';
import 'package:adote_um_pet/android/components/Picker/city_picker.dart';
import 'package:adote_um_pet/android/components/prompts/toast_prompt.dart';
import 'package:adote_um_pet/android/controllers/city_picker_controller.dart';
import 'package:adote_um_pet/android/helpers/pet_files_wrapper.dart';
import 'package:adote_um_pet/android/logic/cubit/pets/pet_cubit.dart';
import 'package:adote_um_pet/android/models/user_entity.dart';
import 'package:adote_um_pet/android/preferences/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/pet_entity.dart';

class PetsPage extends StatefulWidget {
  PetsPage({Key? key}) : super(key: key);

  final CityPickerController cityPickerController = CityPickerController();

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  final PetCubit petCubit = PetCubit();

  @override
  void initState() {
    petCubit.getPets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.yellow[500],
      child: Center(
        child: Scaffold(
          backgroundColor: Colors.yellow[500],
          body: BlocBuilder<PetCubit, PetStates>(
            bloc: petCubit,
            builder: (context, state) {
              if (state is PetLoading) {
                return const Center(child: CustomLoadingBox());
              } else if (state is PetSuccess) {
                return state.pets.isNotEmpty
                    ? filledPetPage(state.pets)
                    : emptyPetPage();
              } else {
                return const Center(
                  child: Text("Erro ao carregar os pets"),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget emptyPetPage() {
    return Column(
      children: [
        Row(
          children: [
            CustomCityPicker(
              cityFilterController:
              widget.cityPickerController.cityFilterController,
              city: widget.cityPickerController.selectedCity,
              state: widget.cityPickerController.selectedState,
              petCubit: petCubit,
            ),
            IconButton(
                onPressed: () {
                  petCubit.addPets(context: context);
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        const Spacer(),
        const Center(child: Text("Nenhum Pet disponível para adoção")),
        const Spacer(
          flex: 2,
        ),
      ],
    );
  }

  Widget filledPetPage(List<PetFilesWrapper> wrappers) {
    return Column(
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          CustomCityPicker(
            cityFilterController:
            widget.cityPickerController.cityFilterController,
            city: widget.cityPickerController.selectedCity,
            state: widget.cityPickerController.selectedState,
            petCubit: petCubit,
          ),
          IconButton(onPressed: () {
            petCubit.addPets(context: context);
          }, icon: const Icon(Icons.add)),
        ]),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: wrappers.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 350,
                crossAxisCount: 1,
                mainAxisSpacing: 25,
              ),
              itemBuilder: (_, index) {
                return PetCard(
                  pet: wrappers[index].pet,
                  files: wrappers[index].files,
                  editable: true,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
