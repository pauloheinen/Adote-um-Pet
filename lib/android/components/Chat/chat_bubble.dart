import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

import '../../models/message_entity.dart';
import '../../models/user_entity.dart';

class BubbleChat extends StatelessWidget {
  final User fromUser;
  final Message message;

  const BubbleChat({
    Key? key,
    required this.fromUser,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSender = message.senderId == fromUser.id;

    return ChatBubble(
      clipper: ChatBubbleClipper1(
        type: isSender ? BubbleType.sendBubble : BubbleType.receiverBubble,
      ),
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      margin: const EdgeInsets.symmetric(vertical: 5),
      backGroundColor: isSender ? Colors.yellow[100] : Colors.grey[100],
      child: Container(
        constraints:
        BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.tsMessage,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
            Text(
              message.messageText,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
