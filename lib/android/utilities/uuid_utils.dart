import 'package:uuid/uuid.dart';

class UUID {
  static String generateUniqueConversationUUID(int id1, int id2) {
    List<int> sortedIds = [id1, id2]..sort();

    String concatenatedIds = '${sortedIds[0]}-${sortedIds[1]}';

    Uuid uuid = const Uuid();
    String uniqueUUID = uuid.v5(Uuid.NAMESPACE_URL, concatenatedIds);

    return uniqueUUID;
  }

  static String retrieveUUIDForConversation(int id1, int id2) {
    return generateUniqueConversationUUID(id1, id2);
  }
}
