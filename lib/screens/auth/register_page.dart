import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final nameCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: auth.isLoading.value
                      ? null
                      : () async {
                          if (emailCtrl.text.isEmpty ||
                              passCtrl.text.isEmpty ||
                              nameCtrl.text.isEmpty) {
                            Get.snackbar('Error', 'Fill all fields');
                            return;
                          }

                          await auth
                              .register(emailCtrl.text.trim(), passCtrl.text, {
                                'name': nameCtrl.text.trim(),
                                'email': emailCtrl.text.trim(),
                                'role': 'user',
                                'createdAt': DateTime.now(),
                              });
                        },
                  child: auth.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
