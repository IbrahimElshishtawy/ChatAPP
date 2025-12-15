import 'package:chat/app/routes/routes.dart';
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

            /// 🌗 Theme
            SwitchListTile(
              title: const Text('الوضع الداكن'),
              value: themeCtrl.isDark.value,
              onChanged: (_) => themeCtrl.toggleTheme(),
              secondary: const Icon(Icons.dark_mode),
            ),

            const Divider(),

            /// 🔔 Notifications
            SwitchListTile(
              title: const Text('الإشعارات'),
              value: settingsCtrl.notificationsEnabled.value,
              onChanged: settingsCtrl.toggleNotifications,
              secondary: const Icon(Icons.notifications),
            ),

            SwitchListTile(
              title: const Text('إشعارات المكالمات'),
              value: settingsCtrl.callNotificationsEnabled.value,
              onChanged: settingsCtrl.toggleCallNotifications,
              secondary: const Icon(Icons.call),
            ),

            const Divider(),

            /// 🌍 Language (جاهزة للتوسعة)
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('اللغة'),
              subtitle: const Text('العربية (قريبًا لغات أخرى)'),
              onTap: () {
                Get.snackbar('قريبًا', 'سيتم إضافة تغيير اللغة قريبًا');
              },
            ),

            const Divider(),

            /// 🚪 Logout
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
