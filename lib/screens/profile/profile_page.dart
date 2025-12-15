import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user/user_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userCtrl = Get.find<UserController>();
    final nameCtrl = TextEditingController(
      text: userCtrl.user.value?.name ?? '',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final user = userCtrl.user.value;
          if (user == null) return const CircularProgressIndicator();

          return Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    await userCtrl.updateProfile(nameCtrl.text.trim());
                    Get.snackbar('Success', 'Profile updated');
                  },
                  child: const Text('Save'),
                ),
              ),
              const SizedBox(height: 12),
              Text('Email: ${user.email}'),
              Text('Role: ${user.role}'),
            ],
          );
        }),
      ),
    );
  }
}
