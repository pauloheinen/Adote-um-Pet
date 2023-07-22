import 'package:adote_um_pet/android/database/database.dart';
import 'package:mysql_client/mysql_client.dart';

import '../entity/pet-file.entity.dart';
import '../entity/pet.entity.dart';

class PetService {
  Future<int?> addPet(Pet pet) async {
    String sql =
        "insert into pets (name, vaccinated, ref_owner) values (?, ?, ?)";

    int? addedPetId = await Database.getInstance()
        .insert(sql, [pet.name, pet.vaccinated, pet.refOwner]);

    return addedPetId;
  }

  Future<bool> updatePet(Pet pet) async {
    String sql =
        "update pets set name = ?, vaccinated = ?, ref_owner = ? where id = ?";

    bool updated = await Database.getInstance()
        .update(sql, [pet.name, pet.vaccinated, pet.refOwner, pet.id]);

    return updated;
  }

  Future<List<Pet>> getPets() async {
    String sql = "select id, name, vaccinated, ref_owner from pets";

    IResultSet results = await Database.getInstance().query(sql, []);

    List<Pet> pets = List.empty(growable: true);

    if (results.rows.firstOrNull == null) {
      return pets;
    }

    for (var element in results) {
      pets.add(Pet.fromJson(element.rows.first.typedAssoc()));
    }

    return pets;
  }

  Future<Map<Pet, PetFile>> getPetsFilesMap() async {
    // TODO implement sql search by city
    String sql =
        "select p.id, p.name, p.vaccinated, p.ref_owner, f.id, f.ref_owner, f.item from pets p, pet_files f where p.id = f.ref_owner";

    IResultSet results = await Database.getInstance().query(sql, []);

    Map<Pet, PetFile> petsFilesMap = {};
    if (results.rows.firstOrNull == null) {
      return petsFilesMap;
    }

    for (var element in results) {
      Pet pet = Pet(
          id: element.rows.first.typedAssoc()['id'],
          name: element.rows.first.typedAssoc()['name'],
          vaccinated: element.rows.first.typedAssoc()['vaccinated'],
          refOwner: element.rows.first.typedAssoc()['ref_owner']);
      PetFile file = PetFile(
          id: element.rows.first.typedAssoc()['id'],
          refOwner: element.rows.first.typedAssoc()['ref_owner'],
          item: element.rows.first.typedAssoc()['item'].toString());
      petsFilesMap.putIfAbsent(pet, () => file);
    }

    return petsFilesMap;
  }
}
