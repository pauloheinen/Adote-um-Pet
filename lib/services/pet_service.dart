import 'package:adote_um_pet/database/database.dart';
import 'package:adote_um_pet/helpers/pet_files_wrapper.dart';
import 'package:adote_um_pet/services/pet_file_service.dart';
import 'package:mysql_client/mysql_client.dart';

import '../models/pet_entity.dart';
import '../models/pet_file_entity.dart';
import '../models/user_entity.dart';

class PetService {
  Future<int?> addPet(Pet pet) async {
    String sql =
        "insert into pets (name, ref_owner, ref_city, info) values (?, ?, ?, ?)";

    int? addedPetId = await Database.getInstance()
        .insert(sql, [pet.name, pet.refOwner, pet.refCity, pet.info]);

    return addedPetId;
  }

  Future<bool> updatePet(Pet pet) async {
    String sql =
        "update pets set name = ?, ref_owner = ?, ref_city = ?, info = ? where id = ?";

    bool updated = await Database.getInstance()
        .update(sql, [pet.name, pet.refOwner, pet.refCity, pet.info, pet.id]);

    return updated;
  }

  Future<bool> deletePet(Pet pet) async {
    String sql = "delete from pets where pets.id = ?";

    return await Database.getInstance().delete(sql, [pet.id]);
  }

  Future<Map<Pet, List<PetFile>>> getPetsFilesMapByCityId(int cityId) async {
    String sql =
        "select p.id, p.name, p.ref_owner, p.ref_city, p.info from pets p where p.ref_city = ?";

    IResultSet results = await Database.getInstance().query(sql, [cityId]);

    Map<Pet, List<PetFile>> petsFilesMap = {};
    if (results.rows.isEmpty) {
      return petsFilesMap;
    }

    for (var element in results.rows) {
      Pet pet = Pet(
          id: element.typedAssoc()['id'],
          name: element.typedAssoc()['name'],
          refOwner: element.typedAssoc()['ref_owner'],
          refCity: element.typedAssoc()['ref_city'],
          info: element.typedAssoc()['info']);
      List<PetFile> files = await PetFileService().getFilesByPet(pet.id!);
      petsFilesMap.putIfAbsent(pet, () => files);
    }

    return petsFilesMap;
  }

  Future<PetFilesWrapper?> getPet(int id) async {
    String sql = "select p.id, p.name, p.ref_owner, p.ref_city, p.info from pets p where p.id = ?";

    IResultSet results =
    await Database.getInstance().query(sql, [id]);

    PetFilesWrapper? pet;

    for (var element in results.rows) {
      pet = PetFilesWrapper(pet: Pet(
          id: element.typedAssoc()['id'],
          name: element.typedAssoc()['name'],
          refOwner: element.typedAssoc()['ref_owner'],
          refCity: element.typedAssoc()['ref_city'],
          info: element.typedAssoc()['info']), files: await PetFileService().getFilesByPet(id));
    }

    return pet;
  }

  Future<Map<Pet, List<PetFile>>> getPetsFilesMapByCityIdAndUser(
      int ibgeCity, User user) async {
    String sql =
        "select p.id, p.name, p.ref_owner, p.ref_city, p.info from pets p where p.ref_city = ? and p.ref_owner = ?;";

    IResultSet results =
    await Database.getInstance().query(sql, [ibgeCity, user.id]);

    Map<Pet, List<PetFile>> petsFilesMap = {};

    if (results.rows.isEmpty) {
      return petsFilesMap;
    }

    for (var element in results.rows) {
      Pet pet = Pet(
          id: element.typedAssoc()['id'],
          name: element.typedAssoc()['name'],
          refOwner: element.typedAssoc()['ref_owner'],
          refCity: element.typedAssoc()['ref_city'],
          info: element.typedAssoc()['info']);

      List<PetFile> files = await PetFileService().getFilesByPet(pet.id!);
      petsFilesMap.putIfAbsent(pet, () => files);
    }

    return petsFilesMap;
  }
}
