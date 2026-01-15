import 'package:chat_setup/controllers/chat/chat_controller.dart';
import 'package:chat_setup/screens/chat/chat_page.dart';
import 'package:chat_setup/screens/home/widgets/empty_chats_view.dart';
import 'package:chat_setup/screens/home/widgets/home_fab.dart';
import 'package:chat_setup/screens/home/widgets/home_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsHomePage extends StatelessWidget {
  const ChatsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatCtrl = Get.find<ChatController>();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final chatsRef = FirebaseFirestore.instance
        .collection('chats')
        .where('members', arrayContains: uid);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : const Color(0xFFF6F7F9),
      body: Stack(
        children: [
          /// 🔹 المحتوى الأساسي
          Column(
            children: [
              /// البار العلوي
              const HomeHeader(),

              /// قائمة الدردشات
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: chatsRef.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const EmptyChatsView();
                    }

                    final chats = snapshot.data!.docs;

                    return ListView.builder(
                      padding: const EdgeInsets.only(
                        bottom: 160, // مساحة للـ FAB + NavBar
                      ),
                      itemCount: chats.length,
                      itemBuilder: (_, i) {
                        final chatId = chats[i].id;

                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: const Text('Chat'),
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
                          onTap: () {
                            Get.to(
                              () => ChatPage(
                                chatId: chatId,
                                otherUserId: 'id',
                                otherUserName: 'User',
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          const Positioned(right: 16, bottom: 130, child: HomeFAB()),
        ],
      ),
    );
  }
}
