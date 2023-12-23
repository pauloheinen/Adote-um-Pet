import 'dart:async';

import 'package:adote_um_pet/android/components/Editor/pet_editor.dart';
import 'package:adote_um_pet/android/helpers/pet_files_wrapper.dart';
import 'package:adote_um_pet/android/models/pet_entity.dart';
import 'package:adote_um_pet/android/models/user_entity.dart';
import 'package:adote_um_pet/android/preferences/preferences.dart';
import 'package:adote_um_pet/android/services/pet_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'pet_states.dart';

class PetCubit extends Cubit<PetStates> {
  PetCubit() : super(PetInitial());

  PetService petService = PetService();

  final List<PetFilesWrapper> _pets = [];

  List<PetFilesWrapper> get pets => _pets;

  Future<void> getPets() async {
    emit(PetLoading());

    try {
      int? ibgeCity = await Preferences.getIbgeCity();

      if (ibgeCity != null) {
        _pets.clear();
        await petService.getPetsFilesMapByCityId(ibgeCity).then((map) => {
          map.forEach((pet, files) {
            _pets.add(PetFilesWrapper(pet: pet, files: files));
          })
        });

        emit(PetSuccess(_pets));
      }
    } catch (e) {
      emit(PetError('Não foi possível carregar a lista de pets!'));
    }
  }

  Future<void> addPets({required BuildContext context}) async {
    try {
      int? ibgeCity = await Preferences.getIbgeCity();

      User user = await Preferences.getUserData();

      Pet pet = Pet(refOwner: user.id!, refCity: ibgeCity!);
      pet.id = await PetService().addPet(pet);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PetEditor(
            buildContext: context,
            pet: pet,
            creational: true,
            callback: () {
              emit(PetSuccess(_pets));
            },
          ),
        ),
      ).then((value) => {
        print("editor fechado, começará a ler os pets"),
        getPets(),
      });
    } catch (error) {
      emit(PetError('Não foi possível adicionar o Pet'));
    }
  }
}
