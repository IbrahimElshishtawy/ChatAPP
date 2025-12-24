import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/chat/chat_controller.dart';

class ChatInputBar extends StatefulWidget {
  final String chatId;
  final String otherUserId;

  const ChatInputBar({
    super.key,
    required this.chatId,
    required this.otherUserId,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final textCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatCtrl = Get.find<ChatController>();

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: textCtrl,
              minLines: 1,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'اكتب رسالة...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              if (textCtrl.text.trim().isEmpty) return;

              chatCtrl.sendMessage(
                chatId: widget.chatId,
                text: textCtrl.text.trim(),
                members: [chatCtrl.uid!, widget.otherUserId],
              );
              textCtrl.clear();
            },
          ),
        ],
      ),
    );
  }
}
