import 'package:chat/app/bindings/auth_bindings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'route_animations.dart';

// Screens (استخدم المسارات الجديدة فقط)
import '../../screens/splash/splash_page.dart';
import '../../screens/auth/login_page.dart';
import '../../screens/auth/register_page.dart';
import '../../screens/home/home_page.dart';
import '../../screens/profile/profile_page.dart';
import '../../screens/settings/settings_page.dart';
import '../../screens/chat/chat_page.dart';
import '../../screens/group/groups_page.dart';
import '../../screens/community/community_page.dart';
import '../../screens/notifications/notifications_page.dart';
import '../../screens/call/call_history_page.dart';

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
    // Splash
    GetPage(name: splash, page: () => const SplashPage()),

    // Auth
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBindings(),
    ),

    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: AuthBindings(),
      customTransition: ScaleFadeTransition(),
      transitionDuration: const Duration(milliseconds: 600),
    ),

    // Home
    GetPage(name: home, page: () => const HomePage()),

    // Profile
    GetPage(name: profile, page: () => const ProfilePage()),

    // Settings
    GetPage(name: settings, page: () => const SettingsPage()),

    // Chat
    GetPage(
      name: chat,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;

        if (args == null ||
            args['id'] == null ||
            args['name'] == null ||
            args['id'] is! String ||
            args['name'] is! String) {
          return const Scaffold(
            body: Center(child: Text('❌ بيانات الشات غير صحيحة')),
          );
        }

        return ChatPage(
          otherUserId: args['id'] as String,
          otherUserName: args['name'] as String,
        );
      },
    ),

    // Groups
    GetPage(name: groups, page: () => const GroupsPage()),

    // Community
    GetPage(name: community, page: () => const CommunityPage()),

    // Notifications
    GetPage(name: notifications, page: () => const NotificationsPage()),

    // Call History
    GetPage(name: callHistory, page: () => const CallHistoryPage()),
  ];
}
