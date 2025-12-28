import 'package:chat/screens/chat/widgets/chat_input_bar.dart';
import 'package:chat/screens/chat/widgets/messages_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/chat/chat_controller.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String otherUserId;
  final String otherUserName;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? selectedChatId;

  @override
  Widget build(BuildContext context) {
    final chatCtrl = Get.find<ChatController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUserName),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // التعامل مع الخيارات المختلفة
              if (value == 'delete') {
                _deleteChat(widget.chatId);
              } else if (value == 'mute') {
                _muteChat(widget.chatId);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'delete',
                child: const Text('حذف الشات'),
              ),
              PopupMenuItem<String>(
                value: 'mute',
                child: const Text('كتم الإشعارات'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // عرض الرسائل
          Expanded(child: MessagesList(chatId: widget.chatId)),

          // إدخال الرسائل
          ChatInputBar(chatId: widget.chatId, otherUserId: widget.otherUserId),
        ],
      ),
    );
  }

  // حذف الشات
  Future<void> _deleteChat(String chatId) async {
    await Get.find<ChatController>().deleteChat(chatId);
    Get.back();
  }

  // كتم الشات
  void _muteChat(String chatId) {
    Get.find<ChatController>().muteChat(chatId);
  }
}
