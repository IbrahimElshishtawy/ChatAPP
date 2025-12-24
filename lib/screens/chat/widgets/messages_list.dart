// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/chat/chat_controller.dart';
import 'message_bubble.dart';

class MessagesList extends StatelessWidget {
  final String chatId;

  const MessagesList({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    final chatCtrl = Get.find<ChatController>();

    return StreamBuilder(
      stream: chatCtrl.getMessages(chatId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;
        chatCtrl.markSeen(chatId);

        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            final isMe = data['senderId'] == chatCtrl.uid;

            return MessageBubble(
              text: data['text'],
              isMe: isMe,
              isSeen: data['isSeen'] ?? false,
            );
          },
        );
      },
    );
  }
}
