import 'package:flutter/material.dart';

class ChatMessagePane extends StatefulWidget {
  @override
  _ChatMessagePaneState createState() => _ChatMessagePaneState();
}

class _ChatMessagePaneState extends State<ChatMessagePane> {
  final TextEditingController _textEditingController = TextEditingController();
  List<String> messages = [];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(messages[index]),
              );
            },
          ),
        ),
        _buildMessageInputField(),
      ],
    );
  }

  Widget _buildMessageInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              onChanged: (text) {
                // Handle text input
              },
              decoration: InputDecoration(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String message = _textEditingController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        messages.add(message);
      });
      _textEditingController.clear();
    }
  }
}
