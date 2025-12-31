import 'package:chat_setup/controllers/chat/chat_controller.dart';
import 'package:chat_setup/screens/chat/chat_page.dart';
import 'package:chat_setup/screens/home/widgets/empty_chats_view.dart';
import 'package:chat_setup/screens/home/widgets/home_fab.dart';
import 'package:chat_setup/screens/home/widgets/home_header.dart';
import 'package:chat_setup/screens/home/widgets/floating_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatCtrl = Get.find<ChatController>();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final chatsRef = FirebaseFirestore.instance
        .collection('chats')
        .where('members', arrayContains: uid);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: isDarkMode ? Colors.black : const Color(0xFFF6F7F9),
          body: Column(
            children: [
              const HomeHeader(),

              /// Chats List
              Expanded(
                child: StreamBuilder(
                  stream: chatsRef.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return EmptyChatsView();
                    }

                    final chats = snapshot.data!.docs;

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 140),
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
                                otherUserId: 'id',
                                otherUserName: 'User',
                                chatId: chatId,
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
        ),

        const HomeFAB(),

        const FloatingNavBar(),
      ],
    );
  }
}
