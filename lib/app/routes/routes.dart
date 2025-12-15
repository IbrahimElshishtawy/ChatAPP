import 'package:chat/core/models/user_model.dart';
import 'package:chat/screen/chat_page.dart';
import 'package:chat/screen/home_page.dart';
import 'package:chat/screen/login_page.dart';
import 'package:chat/screen/rgister_page.dart';
import 'package:chat/screens/auth/login_page.dart';
import 'package:chat/screens/auth/register_page.dart';
import 'package:chat/screens/call/call_history_page.dart';
import 'package:chat/screens/chat/chat_page.dart';
import 'package:chat/screens/community/community_page.dart';
import 'package:chat/screens/group/groups_page.dart';
import 'package:chat/screens/home/home_page.dart';
import 'package:chat/screens/notifications/notifications_page.dart';
import 'package:chat/screens/settings/settings_page.dart';
import 'package:chat/screens/splash/splash_page.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

// ===== Screens =====
import '../../screens/profile/profile_page.dart';

class AppRoutes {
  // ===== Route Names =====
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';

  static const profile = '/profile';
  static const settings = '/settings';

  static const chat = '/chat';

  static const groups = '/groups';
  static const community = '/community';

  static const notifications = '/notifications';

  static const callHistory = '/call-history';

  // ===== Pages =====
  static final pages = <GetPage>[
    /// Splash
    GetPage(name: splash, page: () => const SplashPage()),

    /// Auth
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: register, page: () => const RegisterPage()),

    /// Home (Main Navigation)
    GetPage(name: home, page: () => const HomePage()),

    /// Profile (with arguments)
    GetPage(
      name: profile,
      page: () {
        final args = Get.arguments;

        if (args == null || args is! UserModel) {
          return const Scaffold(
            body: Center(child: Text('❌ لم يتم تمرير بيانات المستخدم')),
          );
        }

        return ProfilePage();
      },
    ),

    /// Settings
    GetPage(name: settings, page: () => const SettingsPage()),

    /// Chat (Private Chat)
    GetPage(
      name: chat,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;

        if (args == null ||
            !args.containsKey('id') ||
            !args.containsKey('name')) {
          return const Scaffold(
            body: Center(child: Text('❌ بيانات الشات غير صحيحة')),
          );
        }

        return ChatPage(otherUserId: args['id'], otherUserName: args['name']);
      },
    ),

    /// Groups
    GetPage(name: groups, page: () => const GroupsPage()),

    /// Community
    GetPage(name: community, page: () => const CommunityPage()),

    /// Notifications
    GetPage(name: notifications, page: () => const NotificationsPage()),

    /// Call History
    GetPage(name: callHistory, page: () => const CallHistoryPage()),
  ];
}
