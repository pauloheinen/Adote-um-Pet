import 'package:adote_um_pet/android/components/Chat/chat_input_bar.dart';
import 'package:adote_um_pet/android/entities/message_entity.dart';
import 'package:adote_um_pet/android/services/message_service.dart';
import 'package:adote_um_pet/android/utilities/Uuid/uuid_utils.dart';
import 'package:adote_um_pet/android/websocket/websocket_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/Chat/chat_message_list.dart';
import '../components/RoundedPhoto/user_photo.dart';
import '../entities/user_entity.dart';

class ChatPage extends StatefulWidget {
  final User fromUser;
  final User toUser;
  final VoidCallback? onConversationUpdated;

  const ChatPage({
    Key? key,
    required this.fromUser,
    required this.toUser,
    this.onConversationUpdated,
  }) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  late TextEditingController _messageController;
  late ScrollController _controller;
  late final WebSocketManager socketManager;

  final List<Message> _messagesList = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _messageController = TextEditingController();
    _controller = ScrollController();

    _loadMessages();

    initSocket();
  }

  void _scrollToLastMessage() {
    _controller.animateTo(
      _controller.position.maxScrollExtent + 60,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }

  void _loadMessages() async {
    _messagesList.clear();
    _messagesList.addAll(await MessageService()
        .getMessagesFromUUID(widget.fromUser, widget.toUser));
    setState(() {});
    _scrollToLastMessage();
  }

  Future<void> initSocket() async {
    socketManager = WebSocketManager.instance;

    await socketManager.initSocket(widget.fromUser,
        onReceiveMessage: (message) {
          receiveMessage(message);
        });
  }

  void receiveMessage(dynamic msg) {
    if (!socketManager.isConnected()) {
      initSocket().then((value) => receiveMessage(msg));
    }

    if (mounted) {
      setState(() {
        Message message = Message.fromJson(msg);
        _messagesList.add(message);
        if (widget.onConversationUpdated != null) {
          widget.onConversationUpdated!();
        }
      });
      _scrollToLastMessage();
    }
  }

  void _sendMessage() async {
    String messageText = _messageController.text.trim();
    _messageController.text = '';
    if (messageText != '') {
      String formattedDate =
      DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

      Message message = Message(
        senderId: widget.fromUser.id!,
        recipientId: widget.toUser.id!,
        messageText: messageText,
        tsMessage: formattedDate,
        uuid: UUID.generateUniqueConversationUUID(
            widget.fromUser.id!, widget.toUser.id!),
      );

      await MessageService().addMessage(message).then((value) => {
        setState(() {
          socketManager.sendMessage(message.toJson());
          _messagesList.add(message);
          if (widget.onConversationUpdated != null) {
            widget.onConversationUpdated!();
          }
        }),
      });

      _scrollToLastMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CustomUserPhoto(
              user: widget.toUser,
              editMode: false,
              photoSize: CustomUserPhoto.appbarSize,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.toUser.name!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          ChatMessageList(
            controller: _controller,
            fromUser: widget.fromUser,
            messages: _messagesList,
          ),
          ChatInputBar(
            messageController: _messageController,
            onSendPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
