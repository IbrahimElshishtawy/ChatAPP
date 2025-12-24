import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat/chat_controller.dart';
import 'widgets/chat_app_bar.dart';
import 'widgets/messages_list.dart';
import 'widgets/chat_input_bar.dart';

class ChatPage extends StatelessWidget {
  final String otherUserId;
  final String otherUserName;

  const ChatPage({
    super.key,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  Widget build(BuildContext context) {
    final chatCtrl = Get.find<ChatController>();
    final chatId = chatCtrl.openChat(otherUserId);
    final uid = chatCtrl.uid ?? Get.parameters['uid'] ?? '';
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),

      appBar: ChatAppBar(name: otherUserName, otherUserId: otherUserId),

      body: Column(
        children: [
      
          Expanded(child: MessagesList(chatId: chatId)),

          
          ChatInputBar(chatId: chatId, otherUserId: otherUserId),
        ],
      ),
    );
  }
}
