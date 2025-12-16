import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../app/routes/routes.dart';
import 'widget/auth_animation.dart';
import 'widget/login_button.dart';
import 'widget/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 🔥 Animation
              const AuthAnimation(asset: 'assets/anim/Phoenix Dancing.json'),

              const SizedBox(height: 24),

              // 📦 Card
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'مرحبًا بعودتك 👋',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 📝 Form
                      LoginForm(emailCtrl: emailCtrl, passCtrl: passCtrl),

                      const SizedBox(height: 24),

                      // 🔘 Button
                      LoginButton(
                        onPressed: () async {
                          if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
                            Get.snackbar('خطأ', 'من فضلك أدخل جميع البيانات');
                            return;
                          }

                          await auth.login(
                            emailCtrl.text.trim(),
                            passCtrl.text,
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.register),
                        child: const Text('إنشاء حساب جديد'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
