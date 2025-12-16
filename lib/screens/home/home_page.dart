import 'package:chat/controllers/chat/chat_controller.dart';
import 'package:chat/screens/chat/chat_page.dart';
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
    final chatCtrl = Get.find<ChatController>();

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text('User not logged in')));
    }

    final uid = currentUser.uid;

    final chatsRef = FirebaseFirestore.instance
        .collection('chats')
        .where('members', arrayContains: uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed(AppRoutes.profile),
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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: chatsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No chats yet'));
          }

          final chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (_, i) {
              final chatDoc = chats[i];
              final chatId = chatDoc.id;

              final members = List<String>.from(
                chatDoc.data()['members'] ?? [],
              );

              final otherUserId = members.firstWhere(
                (id) => id != uid,
                orElse: () => '',
              );

              if (otherUserId.isEmpty) {
                return const SizedBox();
              }

              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),

                title: const Text(
                  'Chat',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // ✅ Last message as Stream
                subtitle: StreamBuilder<String>(
                  stream: chatCtrl.getLastMessageStream(chatId),
                  builder: (_, snap) {
                    return Text(
                      snap.data ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),

                // ✅ Unread message count as Stream
                trailing: StreamBuilder<int>(
                  stream: chatCtrl.getUnreadMessagesStream(chatId),
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
                  if (!chatCtrl.canOpenChat(otherUserId)) return;

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
