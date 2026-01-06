import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/chat/chat_controller.dart';
import 'chat_page.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController chatCtrl = Get.find<ChatController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الدردشات'),
      ),
      body: Obx(() {
        final chats = chatCtrl.chats;

        if (chats.isEmpty) {
          return const Center(
            child: Text('لا توجد محادثات'),
          );
        }

        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];

            return ListTile(
              leading: CircleAvatar(
                child: Text(chat.otherUserName[0]),
              ),
              title: Text(chat.otherUserName),
              subtitle: Text(chat.lastMessage ?? ''),
              onTap: () {
                Get.to(
                  () => ChatPage(
                    chatId: chat.id,
                    otherUserId: chat.otherUserId,
                    otherUserName: chat.otherUserName,
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
