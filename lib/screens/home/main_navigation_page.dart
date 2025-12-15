import 'package:chat/controllers/call/call_controller.dart';
import 'package:chat/screens/call/incoming_call_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/navigation/navigation_controller.dart';
import '../home/home_page.dart';
import '../group/groups_page.dart';
import '../community/community_page.dart';
import '../notifications/notifications_page.dart';
import '../profile/profile_page.dart';

class MainNavigationPage extends StatelessWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavigationController>();

    final pages = [
      const HomePage(),
      const GroupsPage(),
      const CommunityPage(),
      const NotificationsPage(),
      const ProfilePage(),
    ];

    return Obx(() {
      final incoming = Get.find<CallController>().incomingCall.value;

      return Stack(
        children: [
          // تطبيقك الأساسي (الصفحة + navbar)
          Scaffold(
            body: pages[nav.index.value],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: nav.index.value,
              onTap: nav.change,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'الدردشات',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: 'الجروبات',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.public),
                  label: 'المجتمع',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'التنبيهات',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'الملف',
                ),
              ],
            ),
          ),

          // Overlay للمكالمة الواردة
          if (incoming != null)
            Positioned.fill(child: IncomingCallPage(call: incoming)),
        ],
      );
    });
  }
}
