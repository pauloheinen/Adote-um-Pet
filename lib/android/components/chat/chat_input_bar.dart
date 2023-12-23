import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback onSendPressed;

  const ChatInputBar({
    Key? key,
    required this.messageController,
    required this.onSendPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Positioned(
      bottom: 0,
      child: Container(
        height: 60,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size.width * 0.80,
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: TextField(
                controller: messageController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  hintText: "Digite uma mensagem...",
                  labelStyle: TextStyle(fontSize: 15, color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  counterText: '',
                ),
                style: const TextStyle(fontSize: 15),
                keyboardType: TextInputType.text,
                maxLength: 500,
              ),
            ),
            SizedBox(
              width: size.width * 0.20,
              child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: onSendPressed),
            )
          ],
        ),
      ),
    );
  }
}
