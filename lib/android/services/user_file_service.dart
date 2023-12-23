import 'package:adote_um_pet/android/models/user_file_entity.dart';
import 'package:adote_um_pet/android/utilities/file_util.dart';
import 'package:mysql_client/mysql_client.dart';

import '../database/database.dart';

class UserFileService {
  Future<int?> addFile(UserFile file) async {
    String sql = "insert into user_files (ref_owner, item) values (?, ?)";

    int? addedFileId =
    await Database.getInstance().insert(sql, [file.refOwner, file.item]);

    return addedFileId;
  }

  Future<bool> updateFile(UserFile file) async {
    String sql = "update user_files set ref_owner = ?, item = ? where id = ?";

    bool updated = await Database.getInstance()
        .update(sql, [file.refOwner, file.item, file.id]);

    return updated;
  }

  Future<List<UserFile>> getFiles() async {
    String sql = "select id, ref_owner, item from user_files";

    IResultSet results = await Database.getInstance().query(sql, []);

    List<UserFile> files = List.empty(growable: true);

    for (var element in results) {
      files.add(UserFile.fromJson(element.rows.first.typedAssoc()));
    }

    return files;
  }

  Future<String> getProfilePhoto(int id) async {
    String sql = "select item from user_files where id = ?";

    IResultSet results = await Database.getInstance().query(sql, [id]);

    if (results.rows.firstOrNull == null) {
      FileUtil.getDefaultUserImage();
    }

    return results.rows.first.typedAssoc()['item'];
  }
}
