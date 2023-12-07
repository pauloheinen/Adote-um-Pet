import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysql_client/mysql_client.dart';

class Database {
  static MySQLConnection? _conn;
  static final Database _db = Database._();

  Database._();

  static getInstance() {
    return _db;
  }

  Future<MySQLConnection> _createConnection() async {
    await dotenv.load(fileName: "env.env");

    return MySQLConnection.createConnection(
        host: dotenv.get("host"),
        collation: dotenv.get("collation"),
        port: int.parse(dotenv.get("port")),
        userName: dotenv.get("userName"),
        password: dotenv.get("password"),
        databaseName: dotenv.get("databaseName"),
        secure: bool.parse(dotenv.get("secure")));
  }

  Future<MySQLConnection> getConnection() async {
    _conn ??= await _createConnection();

    if (!_conn!.connected) {
      _conn = await _createConnection();
      await _conn!.connect(timeoutMs: 10000);
    }

    return _conn!;
  }

  Future<int> insert(String sql, List<dynamic> params) async {
    _conn = await getConnection();

    PreparedStmt prepared = await _conn!.prepare(sql);
    IResultSet results = await prepared.execute(params);

    await _conn!.close();

    return results.lastInsertID.toInt();
  }

  Future<bool> update(String sql, List<dynamic> params) async {
    _conn = await getConnection();

    PreparedStmt prepared = await _conn!.prepare(sql);
    IResultSet results = await prepared.execute(params);

    return results.affectedRows.toInt() > 0;
  }

  Future<bool> delete(String sql, List<dynamic> params) async {
    _conn = await getConnection();

    PreparedStmt prepared = await _conn!.prepare(sql);
    IResultSet results = await prepared.execute(params);

    return results.affectedRows.toInt() > 0;
  }

  Future<IResultSet> query(String sql, List<dynamic> params) async {
    _conn = await getConnection();

    PreparedStmt prepared = await _conn!.prepare(sql);
    IResultSet results = await prepared.execute(params);

    return results;
  }
}
