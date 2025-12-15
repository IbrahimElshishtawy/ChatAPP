import 'package:chat/controllers/chat/chat_controller.dart';
import 'package:chat/screen/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../controllers/user/user_controller.dart';
import '../../app/routes/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final userCtrl = Get.find<UserController>();

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final chatsRef = FirebaseFirestore.instance
        .collection('chats')
        .where('members', arrayContains: uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              userCtrl.clear();
              Get.offAllNamed(AppRoutes.login);
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: chatsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return const Center(child: Text('No chats yet'));
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (_, i) {
              final chat = chats[i];
              final chatId = chat.id;
              final members = List<String>.from(chat['members']);
              final otherUserId = members.firstWhere((e) => e != uid);

              final chatCtrl = Get.find<ChatController>();

              return ListTile(
                title: Text('Chat'),
                subtitle: StreamBuilder(
                  stream: chatCtrl.getLastMessage(chatId),
                  builder: (_, snap) => Text(snap.data ?? ''),
                ),
                trailing: StreamBuilder<int>(
                  stream: chatCtrl.getUnread(chatId),
                  builder: (_, snap) {
                    final count = snap.data ?? 0;
                    if (count == 0) return const SizedBox();
                    return CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.red,
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
                onTap: () {
                  Get.to(
                    () => ChatPage(
                      otherUserId: otherUserId,
                      otherUserName: 'User',
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
