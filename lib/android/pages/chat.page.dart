import 'package:adote_um_pet/android/components/Chat/chat_input_bar.dart';
import 'package:adote_um_pet/android/entities/message.entity.dart';
import 'package:adote_um_pet/android/services/message_service.dart';
import 'package:adote_um_pet/android/utilities/Uuid/uuid_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../components/Chat/chat_message_list.dart';
import '../components/RoundedPhoto/user.photo.dart';
import '../entities/user.entity.dart';

class ChatPage extends StatefulWidget {
  final User fromUser;
  final User toUser;

  const ChatPage({
    Key? key,
    required this.fromUser,
    required this.toUser,
  }) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  late TextEditingController _messageController;
  late ScrollController _controller;
  late IO.Socket socket;

  List<Message> _messagesList = [];

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _controller = ScrollController();

    _loadMessages();

    initSocket();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToLastMessage);
  }

  void _scrollToLastMessage() {
    _controller.animateTo(
      _controller.position.maxScrollExtent + 60,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }

  Future<void> _loadMessages() async {
    _messagesList.addAll(await MessageService()
        .getMessagesFromUUID(widget.fromUser, widget.toUser));

    setState(() {});
  }

  Future<void> initSocket() async {
    await dotenv.load(fileName: "env.env");

    socket = IO.io(dotenv.get('websocketUrl'), <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {
        'userName': widget.fromUser.name,
      }
    });

    socket.connect();
    socket.onConnect((_) {
      print('connected to websocket');
    });
    socket.on('chat', (message) {
      print("evento de chat dentro do initstate");
      setState(() {
        _messagesList.add(message);
      });
    });
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
          _messagesList.add(message);
        }),
        socket.emit('chat', message.toJson()),
      });

      _scrollToLastMessage();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    socket.disconnect();
    super.dispose();
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
