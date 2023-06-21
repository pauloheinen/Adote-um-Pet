import 'dart:convert';

import 'package:adote_um_pet/android/database/database.dart';
import 'package:adote_um_pet/android/entity/user.entity.dart';
import 'package:mysql1/mysql1.dart';

class UserService {
  Future<int?> addUser(User user) async {
    String sql = "insert into users (name, password, email, phone) values (?, ?, ?, ?)";

    int? addedUserId = await Database().insert(sql, [
      user.name,
      base64.encode(utf8.encode(user.password!)),
      user.email,
      user.phone,
    ]);

    return addedUserId;
  }

  Future<bool> updateUser(User user) async {
    String sql = "update users set name = ?, password = ?, email = ?, phone = ?, image_id = ? where id = ?";

    bool updated = await Database().update(sql, [
      user.name,
      base64.encode(utf8.encode(user.password!)),
      user.email,
      user.phone,
      user.image,
      user.id
    ]);

    return updated;
  }

  Future<User?> getUser(String email, String password) async {
    String sql = "select id, name, password, email, phone, image_id from users where email = ? and password = ?";

    var results = await Database().query(sql, [
      email,
      base64.encode(utf8.encode(password))
    ]);

    return User.fromJson(results.first.fields);
  }

  Future<bool> emailExists(String email) async {
    String sql = "select count(id) from users where email = ?";

    Results results = await Database().query(sql, [
      email
    ]);

    return results.first.fields['count(id)'] > 0;
  }

  Future<bool> phoneExists(String phone) async {
    String sql = "select count(id) from users where phone = ?";

    var results = await Database().query(sql, [
      phone
    ]);

    return results.first.fields['count(id)'] > 0;
  }
}
