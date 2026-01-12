// ignore_for_file: file_names

import 'package:chat_setup/screens/contants_user/widget/Followers_Tab.dart';
import 'package:chat_setup/screens/contants_user/widget/Following_Tab.dart';
import 'package:chat_setup/screens/contants_user/widget/Friends_Tab.dart';
import 'package:chat_setup/screens/contants_user/widget/Requests_Tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/social/friend_controller.dart';
import '../../controllers/social/follow_controller.dart';
import '../../controllers/chat/chat_controller.dart';

class FriendPage extends StatelessWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    final friendCtrl = Get.isRegistered<FriendController>()
        ? Get.find<FriendController>()
        : Get.put(FriendController());

    final followCtrl = Get.isRegistered<FollowController>()
        ? Get.find<FollowController>()
        : Get.put(FollowController());

    final chatCtrl = Get.isRegistered<ChatController>()
        ? Get.find<ChatController>()
        : Get.put(ChatController());

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الأصدقاء والمتابعة'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'الطلبات'),
              Tab(text: 'الأصدقاء'),
              Tab(text: 'المتابعين'),
              Tab(text: 'المتابَعون'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RequestsTab(friendCtrl: friendCtrl, isDark: isDark),
            FriendsTab(
              friendCtrl: friendCtrl,
              chatCtrl: chatCtrl,
              isDark: isDark,
            ),
            FollowersTab(followCtrl: followCtrl, isDark: isDark),
            FollowingTab(followCtrl: followCtrl, isDark: isDark),
          ],
        ),
      ),
    );
  }
}

