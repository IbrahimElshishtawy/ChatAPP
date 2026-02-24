import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user/user_controller.dart';

class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userCtrl = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات الخصوصية')),
      body: Obx(() {
        final user = userCtrl.user.value;
        if (user == null) return const Center(child: CircularProgressIndicator());

        return ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'من يمكنه رؤية...',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            _buildVisibilityTile(
              title: 'الصورة الشخصية',
              currentValue: user.privacySettings['profilePictureVisibility'] ?? 'everyone',
              onChanged: (val) => _updateSetting(userCtrl, 'profilePictureVisibility', val),
            ),
            _buildVisibilityTile(
              title: 'آخر ظهور',
              currentValue: user.privacySettings['lastSeenVisibility'] ?? 'everyone',
              onChanged: (val) => _updateSetting(userCtrl, 'lastSeenVisibility', val),
            ),
            _buildVisibilityTile(
              title: 'الحالة',
              currentValue: user.privacySettings['statusVisibility'] ?? 'everyone',
              onChanged: (val) => _updateSetting(userCtrl, 'statusVisibility', val),
            ),
            const Divider(),
            ListTile(
              title: const Text('المستخدمون المحظورون'),
              trailing: Text('${user.blockedUsers.length}'),
              onTap: () {
                // Navigate to blocked users list
              },
            ),
            ListTile(
              title: const Text('المكالمات المحظورة'),
              trailing: Text('${user.blockedCalls.length}'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('المجموعات المحظورة'),
              trailing: Text('${user.blockedGroups.length}'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: const Text('حذف الحساب', style: TextStyle(color: Colors.red)),
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              onTap: () => _confirmDelete(context, userCtrl),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildVisibilityTile({
    required String title,
    required String currentValue,
    required Function(String) onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(_translateVisibility(currentValue)),
      onTap: () {
        Get.bottomSheet(
          Container(
            color: Colors.white,
            child: Wrap(
              children: [
                _buildOptionTile('الجميع', 'everyone', currentValue, onChanged),
                _buildOptionTile('جهات اتصالي', 'contacts', currentValue, onChanged),
                _buildOptionTile('لا أحد', 'nobody', currentValue, onChanged),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionTile(String label, String value, String currentValue, Function(String) onChanged) {
    return ListTile(
      title: Text(label),
      trailing: value == currentValue ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: () {
        onChanged(value);
        Get.back();
      },
    );
  }

  String _translateVisibility(String val) {
    switch (val) {
      case 'everyone': return 'الجميع';
      case 'contacts': return 'جهات اتصالي';
      case 'nobody': return 'لا أحد';
      default: return val;
    }
  }

  void _updateSetting(UserController ctrl, String key, String value) {
    final settings = Map<String, dynamic>.from(ctrl.user.value!.privacySettings);
    settings[key] = value;
    ctrl.updatePrivacySettings(settings);
  }

  void _confirmDelete(BuildContext context, UserController ctrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الحساب نهائياً؟'),
        content: const Text('لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              ctrl.deleteUserAccount();
              Get.offAllNamed('/login');
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
