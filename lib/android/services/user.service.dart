import 'package:adote_um_pet/android/database/database.dart';
import 'package:adote_um_pet/android/entity/user.entity.dart';
import 'package:mysql_client/mysql_client.dart';

import '../utilities/password.dart';

class UserService {
  Future<int?> addUser(User user) async {
    String sql =
        "insert into users (name, password, email, phone) values (?, ?, ?, ?)";

    int? addedUserId = await Database.getInstance().insert(sql, [
      user.name,
      Password.encrypt(user.password!),
      user.email,
      user.phone,
    ]);

    return addedUserId;
  }

  Future<bool> updateUser(User user) async {
    String sql =
        "update users set name = ?, password = ?, email = ?, phone = ?, image_id = ? where id = ?";

    bool updated = await Database.getInstance().update(sql, [
      user.name,
      Password.encrypt(user.password!),
      user.email,
      user.phone,
      user.imageId,
      user.id
    ]);

    return updated;
  }

  Future<User?> getUser(String email, String password) async {
    String sql =
        "select id, name, password, email, phone, image_id from users where email = ? and password = ?";

    String? hashedPassword = await getPassword(email);
    if (hashedPassword == null) {
      return null;
    }

    if (!Password.checkPassword(password, hashedPassword)) {
      return null;
    }

    IResultSet results =
    await Database.getInstance().query(sql, [email, hashedPassword]);

    if (results.rows.firstOrNull == null) {
      return null;
    }

    return User.fromJson(results.rows.first.typedAssoc());
  }

  Future<String?> getPassword(String email) async {
    String sql = "select password from users where email = ?";

    IResultSet results = await Database.getInstance().query(sql, [email]);

    if (results.rows.firstOrNull == null) {
      return null;
    }

    return results.rows.first.typedAssoc()['password'];
  }

  Future<bool> emailExists(String email) async {
    String sql = "select id from users where email = ?";

    IResultSet results = await Database.getInstance().query(sql, [email]);

    if (results.rows.firstOrNull == null) {
      return false;
    }

    return true;
  }

  Future<bool> phoneExists(String phone) async {
    String sql = "select id from users where phone = ?";

    IResultSet results = await Database.getInstance().query(sql, [phone]);

    if (results.rows.firstOrNull == null) {
      return false;
    }

    return true;
  }
}
