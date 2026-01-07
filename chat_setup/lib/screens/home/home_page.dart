import 'package:chat_setup/screens/home/chats_home_page.dart';
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
    ChatsHomePage(), // 0 - الدردشات
    GroupsPage(), // 1 - الجروبات
    CommunityPage(), // 2 - المجتمع
    NotificationsPage(), // 3 - التنبيهات
    ProfilePage(), // 4 - البروفايل
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            IndexedStack(index: nav.index.value, children: pages),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: FloatingNavBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
