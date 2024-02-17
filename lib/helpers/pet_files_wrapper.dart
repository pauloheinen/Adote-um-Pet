import 'package:adote_um_pet/models/pet_entity.dart';
import 'package:adote_um_pet/models/pet_file_entity.dart';

class PetFilesWrapper {
  Pet pet;
  List<PetFile> files;

  PetFilesWrapper({required this.pet, required this.files});
}
