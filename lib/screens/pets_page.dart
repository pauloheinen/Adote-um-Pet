import 'package:adote_um_pet/components/Loading/loading_box.dart';
import 'package:adote_um_pet/components/Picker/city_picker.dart';
import 'package:adote_um_pet/components/card/pet/pet_card.dart';
import 'package:adote_um_pet/components/panes/empty_state.dart';
import 'package:adote_um_pet/controllers/city_picker_controller.dart';
import 'package:adote_um_pet/helpers/pet_files_wrapper.dart';
import 'package:adote_um_pet/logic/cubit/pet/pet_cubit.dart';
import 'package:adote_um_pet/models/user_entity.dart';
import 'package:adote_um_pet/preferences/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PetsPage extends StatelessWidget {
  final CityPickerController cityPickerController = CityPickerController();

  PetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PetCubit()..getPets(),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<PetCubit, PetStates>(
            builder: (context, state) {
              if (state is PetLoading) {
                return const Center(child: CustomLoadingBox());
              } else if (state is PetSuccess) {
                return state.pets.isNotEmpty
                    ? filledPetPage(context, state.pets)
                    : emptyPetPage(context);
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

  Widget emptyPetPage(BuildContext context) {
    final petCubit = context.read<PetCubit>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomCityPicker(
              cityFilterController: cityPickerController.cityFilterController,
              city: cityPickerController.selectedCity,
              state: cityPickerController.selectedState,
              petCubit: petCubit,
            ),
            IconButton(
              onPressed: () {
                petCubit.addPet(context: context);
              },
              icon: const Icon(Icons.add,
                  color: Color.fromARGB(255, 221, 161, 94)),
            ),
          ],
        ),
        const Expanded(
            child: EmptyStatePane(
                description:
                "Não há Pets disponíveis para adotar.\nTente procurar por Pets em outra região"),),
      ],
    );
  }

  Widget filledPetPage(BuildContext context, List<PetFilesWrapper> wrappers) {
    return FutureBuilder<User>(
      future: Preferences.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomLoadingBox();
        } else if (snapshot.hasError) {
          return const Center(child: Text("Erro ao carregar o usuário atual"));
        } else {
          final actualUser = snapshot.data;
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomCityPicker(
                    cityFilterController:
                    cityPickerController.cityFilterController,
                    city: cityPickerController.selectedCity,
                    state: cityPickerController.selectedState,
                    petCubit: context.read<PetCubit>(),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<PetCubit>().addPet(context: context);
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: GridView.builder(
                    key: UniqueKey(),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: wrappers.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 350,
                      crossAxisCount: 1,
                      mainAxisSpacing: 25,
                    ),
                    itemBuilder: (_, index) {
                      return PetCard(
                        pet: wrappers[index].pet,
                        files: wrappers[index].files,
                        editable: true,
                        actualUser: actualUser!,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
