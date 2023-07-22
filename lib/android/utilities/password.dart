import 'package:bcrypt/bcrypt.dart';

class Password {
  static String encrypt(String password) {
    String hashed = BCrypt.hashpw(password, BCrypt.gensalt(logRounds: 12));
    hashed = _addSalt(hashed);
    return hashed;
  }

  static String decrypt(String password) {
    String hashed = encrypt(password);

    if (BCrypt.checkpw(password, _removeSalt(hashed))) {
      return password;
    }

    throw Exception("Um erro ocorreu ao decriptar senha $password");
  }

  static bool checkPassword(String password, String hashed) {
    return BCrypt.checkpw(password, _removeSalt(hashed));
  }

  static String _removeSalt(String text) {
    return text.substring(2, text.length - 2);
  }

  static String _addSalt(String text) {
    return "<<$text>>";
  }
}
