class Message {
  int? id;
  int senderId;
  int recipientId;
  String messageText;
  String tsMessage;
  String uuid;

  Message({
    this.id,
    required this.senderId,
    required this.recipientId,
    required this.messageText,
    required this.tsMessage,
    required this.uuid,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'recipient_id': recipientId,
      'message_text': messageText,
      'ts_message': tsMessage,
      'uuid': uuid,
    };
  }

  factory Message.fromJson(Map<String, dynamic> message) {
    String tsMessage = message['ts_message'];
    tsMessage =
        tsMessage.replaceAll('-', '/').substring(0, tsMessage.lastIndexOf(':'));

    return Message(
      id: message['id'],
      senderId: message['sender_id'],
      recipientId: message['recipient_id'],
      messageText: message['message_text'],
      tsMessage: tsMessage,
      uuid: message['uuid'],
    );
  }
}
