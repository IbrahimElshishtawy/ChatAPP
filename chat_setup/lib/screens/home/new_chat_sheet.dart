// ignore_for_file: avoid_print, strict_top_level_inference, unnecessary_underscores

import 'package:chat/controllers/chat/chat_controller.dart';
import 'package:chat/screens/chat/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/user/user_controller.dart';

class NewChatSheet extends StatelessWidget {
  const NewChatSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final userCtrl = Get.find<UserController>();
    final chatCtrl = Get.find<ChatController>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ⬆ Drag Handle
          Center(
            child: Container(
              width: 42,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          const Text(
            'شات جديد',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          /// 🔍 Search
          TextField(
            onChanged: userCtrl.search,
            decoration: InputDecoration(
              hintText: 'ابحث بالاسم أو الهاتف أو الإيميل',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// 👥 Users List
          Expanded(
            child: Obx(() {
              final users = userCtrl.filteredUsers;

              // Set to keep track of emails that have been shown
              Set<String> displayedEmails = {};

              if (users.isEmpty) {
                return const Center(
                  child: Text(
                    'لا يوجد مستخدمين',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.separated(
                itemCount: users.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final u = users[i];

                  // Check if the email has already been displayed
                  if (displayedEmails.contains(u.email)) {
                    return const SizedBox.shrink(); // Skip this user
                  }

                  // Add the email to the set to ensure it won't be repeated
                  displayedEmails.add(u.email ?? "");

                  return FutureBuilder<bool>(
                    future: _isUserValid(u),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }

                      if (!snapshot.hasData || snapshot.data != true) {
                        return const SizedBox.shrink();
                      }

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            u.name.isNotEmpty ? u.name[0] : '?',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(u.name),
                        subtitle: Text(
                          (u.phone ?? '').isNotEmpty
                              ? u.phone!
                              : (u.email ?? ''),
                          style: const TextStyle(fontSize: 12),
                        ),
                        onTap: () async {
                          final myId = chatCtrl.uid;
                          if (myId == null) return;

                          final chatId = chatCtrl.openChat(u.id);

                          await chatCtrl.openOrCreateChat(u.id);
                          await chatCtrl.ensureChat(
                            chatId: await chatId,
                            members: [myId, u.id],
                          );

                          Get.back();

                          Get.to(
                            () => ChatPage(
                              otherUserId: u.id,
                              otherUserName: u.name,
                              chatId: '',
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // تحقق من أن المستخدم موجود في Firebase Authentication و Firestore
  Future<bool> _isUserValid(user) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .get();

      if (!userDoc.exists) {
        return false;
      }

      return true;
    } catch (e) {
      //  ('Error validating user: $e');
      kDebugMode ? print('Error validating user: $e') : null;
      return false;
    }
  }
}
