import 'package:chat/screens/auth/widget/auth_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widget/auth_background.dart';
import 'widget/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AuthAnimation(asset: 'assets/anim/Welcome.json'),
                const Text(
                  'Create Account ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                const RegisterForm(),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'لديك حساب؟ تسجيل الدخول',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(254, 255, 254, 254),
                    ),
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
