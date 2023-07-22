import 'package:mysql_client/mysql_client.dart';

import '../database/database.dart';
import '../entity/pet-file.entity.dart';
import '../entity/pet.entity.dart';

class PetFileService {
  Future<int?> addFile(PetFile file) async {
    String sql = "insert into pet_files (ref_owner, item) values (?, ?)";

    int? addedFileId = await Database.getInstance().insert(sql, [file.refOwner, file.item]);

    return addedFileId;
  }

  Future<bool> updateFile(PetFile file) async {
    String sql = "update pet_files set ref_owner = ?, item = ? where id = ?";

    bool updated =
    await Database.getInstance().update(sql, [file.refOwner, file.item, file.id]);

    return updated;
  }

  Future<List<PetFile>> getFiles() async {
    String sql = "select id, ref_owner, item from pet_files";

    IResultSet results = await Database.getInstance().query(sql, []);

    List<PetFile> files = List.empty(growable: true);

    for (var element in results) {
      files.add(PetFile.fromJson(element.rows.first.typedAssoc()));
    }

    return files;
  }

  Future<List<PetFile>> getFilesByPet(Pet pet) async {
    String sql = "select id, ref_owner, item from pet_files where id = ?";

    IResultSet results = await Database.getInstance().query(sql, [pet.id]);

    List<PetFile> files = List.empty(growable: true);

    for (var element in results) {
      files.add(PetFile.fromJson(element.rows.first.typedAssoc()));
    }

    return files;
  }
}
