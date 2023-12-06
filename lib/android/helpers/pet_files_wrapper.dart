import 'package:adote_um_pet/android/entities/pet_entity.dart';
import 'package:adote_um_pet/android/entities/pet_file_entity.dart';

class PetFilesWrapper {
  Pet pet;
  List<PetFile> files;

  PetFilesWrapper({required this.pet, required this.files});
}
