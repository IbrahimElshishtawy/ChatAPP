import 'package:chat_setup/controllers/call/call_controller.dart';
import 'package:chat_setup/screens/call/incoming_call_page.dart';
import 'package:chat_setup/screens/home/widgets/floating_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../controllers/navigation/navigation_controller.dart';
import '../home/home_page.dart';
import '../group/groups_page.dart';
import '../community/community_page.dart';
import '../notifications/notifications_page.dart';
import '../profile/profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  @override
  void initState() {
    super.initState();
    _listenToFCM();
  }

  void _listenToFCM() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final type = message.data['type'];

      if (type == 'call') {
        debugPrint('📞 Call notification clicked');
      }
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavigationController>();

    final pages = const [
      HomePage(),
      GroupsPage(),
      CommunityPage(),
      NotificationsPage(),
      ProfilePage(),
    ];

    return Obx(() {
      final incoming = Get.find<CallController>().incomingCall.value;

      return Stack(
        children: [
          /// الصفحات (محفوظة)
          Scaffold(
            body: IndexedStack(index: nav.index.value, children: pages),
          ),

          /// Floating Navigation
          const FloatingNavBar(),

          /// Incoming Call Overlay
          if (incoming != null)
            Positioned.fill(child: IncomingCallPage(call: incoming)),
        ],
      );
    });
  }
}
