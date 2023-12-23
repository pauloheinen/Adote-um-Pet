import 'package:adote_um_pet/android/models/user_entity.dart';
import 'package:adote_um_pet/android/services/user_service.dart';
import 'package:mysql_client/mysql_client.dart';

import '../database/database.dart';
import '../models/message_entity.dart';
import '../utilities/uuid_utils.dart';

class MessageService {
  Future<int?> addMessage(Message message) async {
    String sql =
        "insert into messages (sender_id, recipient_id, message_text, ts_message, uuid) values (?, ?, ?, STR_TO_DATE(?, '%d/%m/%Y %H:%i'), ?)";

    int? addedMessageId = await Database.getInstance().insert(sql, [
      message.senderId,
      message.recipientId,
      message.messageText,
      message.tsMessage,
      UUID.retrieveUUIDForConversation(message.senderId, message.recipientId),
    ]);

    return addedMessageId;
  }

  Future<List<Message>> getMessagesFromUUID(User fromUser, User toUser) async {
    String sql =
        "select id, sender_id, recipient_id, message_text, ts_message, uuid from messages where uuid = ?";

    IResultSet results = await Database.getInstance().query(
        sql, [UUID.generateUniqueConversationUUID(fromUser.id!, toUser.id!)]);

    List<Message> messages = List.empty(growable: true);

    if (results.rows.firstOrNull == null) {
      return messages;
    }

    for (var element in results.rows) {
      messages.add(Message.fromJson(element.typedAssoc()));
    }

    return messages;
  }

  Future<Map<Message, Map<User, User>>> getMessagesFromUser(User user) async {
    String sql = """
                  select m.*
                  from messages m
                  where 
                  m.id = ( select MAX(m2.id) from messages m2 where m2.sender_id = ?
                  or m2.recipient_id = ? )
                  and ( m.sender_id = ? or m.recipient_id = ? )
                  group by m.uuid""";

    IResultSet results =
    await Database.getInstance().query(sql, [user.id, user.id, user.id, user.id]);

    Map<Message, Map<User, User>> messages = {};

    if (results.rows.firstOrNull == null) {
      return messages;
    }

    for (var element in results.rows) {
      Message message = Message(
        id: element.typedAssoc()['id'],
        senderId: element.typedAssoc()['sender_id'],
        recipientId: element.typedAssoc()['recipient_id'],
        messageText: element.typedAssoc()['message_text'],
        tsMessage: element.typedAssoc()['ts_message'],
        uuid: element.typedAssoc()['uuid'],
      );

      User? senderUser = await UserService().getUserById(message.senderId);
      User? recipientUser =
      await UserService().getUserById(message.recipientId);

      messages.addAll({
        message: {senderUser!: recipientUser!}
      });
    }

    return messages;
  }
}
