import 'package:adote_um_pet/android/database/database.dart';

import '../entity/pet.entity.dart';

class PetService {
  Future<int?> addPet(Pet pet) async {
    String sql =
        "insert into pets (name, vaccinated, ref_owner) values (?, ?, ?)";

    int? addedPetId =
        await Database().insert(sql, [pet.name, pet.vaccinated, pet.refOwner]);

    return addedPetId;
  }

  Future<bool> updatePet(Pet pet) async {
    String sql =
        "update pets set name = ?, vaccinated = ?, ref_owner = ? where id = ?";

    bool updated = await Database()
        .update(sql, [pet.name, pet.vaccinated, pet.refOwner, pet.id]);

    return updated;
  }

  Future<List<Pet>> getPets() async {
    String sql = "select id, name, vaccinated, ref_owner from pets";

    var results = await Database().query(sql, []);

    List<Pet> pets = List.empty(growable: true);

    for (var element in results) {
      pets.add(Pet.fromJson(element.fields));
    }

    return pets;
  }
}
