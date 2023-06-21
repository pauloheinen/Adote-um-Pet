import 'package:mysql1/mysql1.dart';

class Database {
  final ConnectionSettings _connectionSettings = ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'root',
      password: 'root',
      db: 'petdb');

  Database();

  Future<MySqlConnection> getConnection() async {
    return await MySqlConnection.connect(_connectionSettings);
  }

  Future<int?> insert(String sql, List<dynamic> params) async {
    MySqlConnection conn = await getConnection();

    Results results = await conn.query(sql, params);

    conn.close();

    return results.insertId;
  }

  Future<bool> update(String sql, List<dynamic> params) async {
    MySqlConnection conn = await getConnection();

    Results results = await conn.query(sql, params);

    conn.close();

    return results.affectedRows! > 0;
  }

  Future<Results> query(String sql, List<dynamic> params) async {
    MySqlConnection conn = await getConnection();

    Results results = await conn.query(sql, params);

    conn.close();

    return results;
  }
}
