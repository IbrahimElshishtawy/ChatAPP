import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat/chat_controller.dart';
import '../../core/models/chat_model.dart';

class ChatSettingsPage extends StatelessWidget {
  final String chatId;
  final ChatModel chat;

  const ChatSettingsPage({super.key, required this.chatId, required this.chat});

  @override
  Widget build(BuildContext context) {
    final chatCtrl = Get.find<ChatController>();
    final myId = chatCtrl.uid;

    if (myId == null) return const SizedBox();

    final mySettings = chat.settings[myId] ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات المحادثة')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('كتم التنبيهات'),
            secondary: const Icon(Icons.notifications_off),
            value: mySettings['muted'] ?? false,
            onChanged: (val) {
              final newSettings = Map<String, dynamic>.from(mySettings);
              newSettings['muted'] = val;
              chatCtrl.updateChatSettings(chatId, newSettings);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('مسح الرسائل'),
            leading: const Icon(Icons.clear_all),
            onTap: () {
              // Logic to clear messages locally or for user
            },
          ),
          ListTile(
            title: const Text('حذف المحادثة', style: TextStyle(color: Colors.red)),
            leading: const Icon(Icons.delete, color: Colors.red),
            onTap: () => _confirmDelete(context, chatCtrl),
          ),
          const Divider(),
          if (chat.type == ChatType.group) ...[
             ListTile(
              title: const Text('أعضاء المجموعة'),
              leading: const Icon(Icons.people),
              trailing: Text('${chat.members.length}'),
              onTap: () {},
            ),
          ],
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, ChatController ctrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المحادثة؟'),
        content: const Text('سيتم حذف هذه المحادثة من قائمتك.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              ctrl.deleteChatForMe(chatId);
              Get.back();
              Get.back(); // Back to chats list
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
