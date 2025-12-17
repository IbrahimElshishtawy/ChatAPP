import 'package:chat/controllers/chat/chat_controller.dart';
import 'package:chat/screens/chat/chat_page.dart';
import 'package:chat/screens/home/widgets/home_fab.dart';
import 'package:chat/screens/home/widgets/home_header.dart';
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
    final chatCtrl = Get.find<ChatController>();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final chatsRef = FirebaseFirestore.instance
        .collection('chats')
        .where('members', arrayContains: uid);

    return Stack(
      children: [
        Scaffold(
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
                      return const Center(child: Text('لا توجد محادثات'));
                    }

                    final chats = snapshot.data!.docs;

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 120),
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

        /// FAB
        const HomeFAB(),
      ],
    );
  }
}
