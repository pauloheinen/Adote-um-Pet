import 'package:mysql_client/mysql_client.dart';

import '../database/database.dart';
import '../models/pet_file_entity.dart';
import '../models/pet_entity.dart';

class PetFileService {
  Future<int?> addFile(PetFile file) async {
    String sql = "insert into pet_files (ref_pet, item) values (?, ?)";

    int? addedFileId =
    await Database.getInstance().insert(sql, [file.refPet, file.item]);

    return addedFileId;
  }

  Future<List<int?>> addFiles(List<PetFile> files) async {
    String sql = "insert into pet_files (ref_pet, item) values (?, ?)";

    List<int?> addedFilesId = [];

    for (int i = 0; i < files.length; i++) {
      PetFile file = files[i];

      addedFilesId.add(
          await Database.getInstance().insert(sql, [file.refPet, file.item]));
    }
    return addedFilesId;
  }

  Future<bool> updateFile(PetFile file) async {
    String sql = "update pet_files set ref_pet = ?, item = ? where id = ?";

    bool updated = await Database.getInstance()
        .update(sql, [file.refPet, file.item, file.id]);

    return updated;
  }

  Future<bool> deletePetFile(PetFile petFile) async {
    String sql = "delete from pet_files where id = ?";

    return await Database.getInstance().delete(sql, [petFile.id]);
  }

  Future<bool> deletePetFiles(Pet pet) async {
    String sql = "delete from pet_files where ref_pet = ?";

    return await Database.getInstance().delete(sql, [pet.id]);
  }

  Future<List<PetFile>> getFiles() async {
    String sql = "select id, ref_pet, item from pet_files";

    IResultSet results = await Database.getInstance().query(sql, []);

    List<PetFile> files = List.empty(growable: true);

    for (var element in results) {
      files.add(PetFile.fromJson(element.rows.first.typedAssoc()));
    }

    return files;
  }

  Future<List<PetFile>> getFilesByPet(int id) async {
    String sql = "select id, ref_pet, item from pet_files where ref_pet = ?";

    IResultSet results = await Database.getInstance().query(sql, [id]);

    List<PetFile> files = List.empty(growable: true);

    if (results.rows.isEmpty) {
      return files;
    }

    for (var element in results.rows) {
      files.add(PetFile.fromJson(element.typedAssoc()));
    }

    return files;
  }
}
