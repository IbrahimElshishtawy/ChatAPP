import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:chat/screens/auth/widget/auth_background.dart';
import 'package:chat/screens/auth/widget/auth_card.dart';
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

    Future<void> onLogin() async {
      if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
        Get.snackbar('خطأ', 'من فضلك أدخل البريد الإلكتروني وكلمة المرور');
        return;
      }

      await auth.login(emailCtrl.text.trim(), passCtrl.text);
    }

    return Scaffold(
      body: AuthBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const AuthAnimation(asset: 'assets/anim/Phoenix Dancing.json'),
                const SizedBox(height: 2),

                // 📦 Card
                AuthCard(
                  child: Column(
                    children: [
                      const Text(
                        'Welcome Back ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 📝 Form
                      LoginForm(emailCtrl: emailCtrl, passCtrl: passCtrl),

                      const SizedBox(height: 24),

                      // 🔘 Button
                      LoginButton(onPressed: onLogin),

                      const SizedBox(height: 12),

                      TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.register),
                        child: const Text(
                          'إنشاء حساب جديد',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
