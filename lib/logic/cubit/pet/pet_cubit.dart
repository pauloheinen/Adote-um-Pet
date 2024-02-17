import 'dart:async';

import 'package:adote_um_pet/components/Editor/pet_editor.dart';
import 'package:adote_um_pet/helpers/pet_files_wrapper.dart';
import 'package:adote_um_pet/models/pet_entity.dart';
import 'package:adote_um_pet/models/user_entity.dart';
import 'package:adote_um_pet/preferences/preferences.dart';
import 'package:adote_um_pet/services/pet_service.dart';
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
      }
      emit(PetSuccess(_pets));
    } catch (e) {
      emit(PetError('Não foi possível carregar a lista de pet!'));
    }
  }

  Future<void> addPet({required BuildContext context}) async {
    try {
      int? ibgeCity = await Preferences.getIbgeCity();

      User user = await Preferences.getUserData();

      Pet pet = Pet(refOwner: user.id!, refCity: ibgeCity!);
      await petService.addPet(pet).then((petId) => {
        pet.id = petId,
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetEditor(
              buildContext: context,
              pet: pet,
              creational: true,
            ),
          ),
        ).then((value) => {
          getPets(),
        })
      });
    } catch (error) {
      emit(PetError('Não foi possível adicionar o Pet'));
    }
  }

  Future<void> updatePet({required Pet pet}) async {
    try {
      await petService.updatePet(pet);
      emit(PetSuccess(_pets));
    } catch (error) {
      emit(PetError('Não foi possível atualizar o Pet'));
    }
  }

  Future<void> deletePet({required Pet pet}) async {
    try {
      await petService.deletePet(pet);
      await getPets();
      emit(PetSuccess(_pets));
    } catch (e) {
      emit(PetError("Erro ao excluir o pet"));
    }
  }
}
