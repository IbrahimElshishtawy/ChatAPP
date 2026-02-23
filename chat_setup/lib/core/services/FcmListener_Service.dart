// ignore_for_file: file_names

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FcmListenerService {
  void listen() {
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      // اعرض Snackbar / Local Notification
      final title = msg.notification?.title ?? '';
      final body = msg.notification?.body ?? '';
      if (title.isNotEmpty || body.isNotEmpty) {
        Get.snackbar(title, body);
      }
    });

    // لما المستخدم يضغط على الإشعار والتطبيق كان بالخلفية
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
      _handleNotificationClick(msg);
    });
  }

  void _handleNotificationClick(RemoteMessage msg) {
    final type = msg.data['type'];
    final id = msg.data['id'];

    if (type == 'chat') {
      Get.toNamed('/chat', arguments: id);
    } else if (type == 'group') {
      Get.toNamed('/group_chat', arguments: id);
    } else if (type == 'channel') {
      Get.toNamed('/channel_chat', arguments: id);
    } else if (type == 'follow') {
      Get.toNamed('/profile', arguments: id);
    }
  }
}
