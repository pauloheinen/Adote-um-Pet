import 'package:adote_um_pet/android/entities/pet_entity.dart';
import 'package:adote_um_pet/android/entities/pet_file_entity.dart';

class PetFilesWrapper {
  final Pet pet;
  final List<PetFile> files;

  PetFilesWrapper({required this.pet, required this.files});

  Pet get getPet => pet;

  List<PetFile> get getPetFiles => files;

  set petFiles(List<PetFile> petFiles) {
  files.clear();
  files.addAll(petFiles);
  }
}
