import 'package:adote_um_pet/android/components/rounded_photo/user_photo.dart';
import 'package:adote_um_pet/android/models/message_entity.dart';
import 'package:adote_um_pet/android/models/user_entity.dart';
import 'package:adote_um_pet/android/preferences/preferences.dart';
import 'package:adote_um_pet/android/services/message_service.dart';
import 'package:adote_um_pet/android/websocket/websocket_manager.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  User? actualUser;
  Map<Message, Map<User, User>> _messagesAndUsersMap = {};
  List<Color> backgroundColors = [Colors.lightGreen[300]!, Colors.yellow[300]!];
  late final WebSocketManager socketManager;

  @override
  void dispose() {
    if (socketManager.isConnected()) {
      socketManager.disconnectSocket();
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _loadMessagesAndUsers().then((value) => {initWebSocket()});
  }

  Future<void> _loadMessagesAndUsers() async {
    actualUser = await Preferences.getUserData();

    refreshPage();
  }

  Future<void> initWebSocket() async {
    socketManager = WebSocketManager.instance;
    await socketManager.initSocket(actualUser!, onReceiveMessage: (message) {
      if (socketManager.isConnected()) {
        refreshPage();
      }
    });
  }

  Future<void> refreshPage() async {
    if (mounted) {
      _messagesAndUsersMap =
      await MessageService().getMessagesFromUser(actualUser!);

      setState(() {});
    }
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
                      Icon(message.senderId == actualUser!.id
                          ? Icons.call_made
                          : Icons.call_received),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          message.messageText,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    _openChat(message.senderId == actualUser!.id
                        ? recipientUser
                        : senderUser);
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
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          fromUser: actualUser!,
          toUser: sendToUser,
          onConversationUpdated: () {
            refreshPage();
          },
        ),
      ),
    )
        .then((value) => refreshPage());
  }
}
