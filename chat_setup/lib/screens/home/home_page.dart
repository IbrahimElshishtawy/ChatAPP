import 'package:chat_setup/screens/chat/chats_home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/navigation/navigation_controller.dart';

import '../group/groups_page.dart';
import '../community/community_page.dart';
import '../notifications/notifications_page.dart';
import '../profile/profile_page.dart';
import 'widgets/floating_nav_bar.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final NavigationController nav = Get.put(
    NavigationController(),
    permanent: true,
  );

  final List<Widget> pages = const [
    ChatsPage(),
    GroupsPage(),
    CommunityPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            IndexedStack(index: nav.index.value, children: pages),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FloatingNavBar(),
              ),
            ),
          ],
        );
      }),
    );
  }
}
