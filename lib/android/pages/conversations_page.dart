import 'package:adote_um_pet/android/components/RoundedPhoto/user.photo.dart';
import 'package:adote_um_pet/android/entities/message.entity.dart';
import 'package:adote_um_pet/android/entities/user.entity.dart';
import 'package:adote_um_pet/android/preferences/preferences.dart';
import 'package:adote_um_pet/android/services/message_service.dart';
import 'package:flutter/material.dart';

import 'chat.page.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  User? actualUser;
  Map<Message, Map<User, User>> _messagesAndUsersMap = {};
  List<Color> backgroundColors = [Colors.lightGreen[300]!, Colors.yellow[300]!];

  @override
  void initState() {
    super.initState();

    _loadMessagesAndUsers();
  }

  Future<void> _loadMessagesAndUsers() async {
    actualUser = await Preferences.getUserData();
    _messagesAndUsersMap =
    await MessageService().getMessagesFromUser(actualUser!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _messagesAndUsersMap.length,
        itemBuilder: (context, index) {
          Message message = _messagesAndUsersMap.keys.elementAt(index);
          User senderUser =
          _messagesAndUsersMap.values.elementAt(index).keys.elementAt(0);
          User recipientUser =
          _messagesAndUsersMap.values.elementAt(index).values.elementAt(0);

          Color backgroundColor =
          backgroundColors[index % backgroundColors.length];

          return Column(
            children: [
              Container(
                color: backgroundColor,
                child: ListTile(
                  leading: SizedBox(
                    width: 56,
                    child: CustomUserPhoto(
                      user: senderUser,
                      editMode: false,
                      photoSize: CustomUserPhoto.appbarSize,
                    ),
                  ),
                  title: message.senderId == actualUser!.id
                      ? Text(recipientUser.name!)
                      : Text(senderUser.name!),
                  subtitle: Row(
                    children: [
                      message.senderId == actualUser!.id
                          ? const Icon(Icons.call_made)
                          : const Icon(Icons.call_received),
                      const SizedBox(width: 5),
                      Text(message.messageText),
                    ],
                  ),
                  onTap: () => {
                    _openChat(message.senderId == actualUser!.id
                        ? recipientUser
                        : senderUser),
                  },
                ),
              ),
              const Divider(
                height: 1,
                color: Colors.grey,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openChat(User sendToUser) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          fromUser: actualUser!,
          toUser: sendToUser,
        ),
      ),
    ).then((value) => _loadMessagesAndUsers());
  }
}
