import 'package:chat_setup/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme/theme_controller.dart';
import '../../controllers/settings/settings_controller.dart';
import '../../controllers/auth/auth_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();
    final settingsCtrl = Get.find<SettingsController>();
    final authCtrl = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: Obx(
        () => ListView(
          children: [
            const SizedBox(height: 8),

            ListTile(
              title: const Text('المظهر (Dark Mode)'),
              trailing: Switch(
                value: themeCtrl.isDark.value,
                onChanged: (_) => themeCtrl.toggleTheme(),
              ),
              leading: const Icon(Icons.brightness_4),
            ),

            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'الإشعارات',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),

            SwitchListTile(
              title: const Text('إشعارات الرسائل الخاصة'),
              value: settingsCtrl.notificationsEnabled.value,
              onChanged: settingsCtrl.toggleNotifications,
              secondary: const Icon(Icons.message),
            ),

            SwitchListTile(
              title: const Text('إشعارات المجموعات'),
              value: settingsCtrl.groupNotificationsEnabled.value,
              onChanged: settingsCtrl.toggleGroupNotifications,
              secondary: const Icon(Icons.group),
            ),

            SwitchListTile(
              title: const Text('إشعارات القنوات'),
              value: settingsCtrl.channelNotificationsEnabled.value,
              onChanged: settingsCtrl.toggleChannelNotifications,
              secondary: const Icon(Icons.podcasts),
            ),

            SwitchListTile(
              title: const Text('إشعارات المكالمات'),
              value: settingsCtrl.callNotificationsEnabled.value,
              onChanged: settingsCtrl.toggleCallNotifications,
              secondary: const Icon(Icons.call),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('اللغة'),
              subtitle: const Text('العربية (قريبًا لغات أخرى)'),
              onTap: () {
                Get.snackbar('قريبًا', 'سيتم إضافة تغيير اللغة قريبًا');
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await authCtrl.logout();
                Get.offAllNamed(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
