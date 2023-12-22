import 'package:adote_um_pet/android/models/message_entity.dart';
import 'package:flutter/material.dart';

import '../../models/user_entity.dart';
import 'chat_bubble.dart';

class ChatMessageList extends StatelessWidget {
  final ScrollController controller;
  final User fromUser;
  final List<Message> messages;

  const ChatMessageList({
    Key? key,
    required this.controller,
    required this.fromUser,
    required this.messages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 60,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        reverse: false,
        cacheExtent: 1000,
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          Message message =
          messages[index];

          return BubbleChat(
            fromUser: fromUser,
            message: message,
          );
        },
      ),
    );
  }
}
