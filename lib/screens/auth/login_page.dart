import 'package:chat/screens/auth/widget/login_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../../controllers/auth/auth_controller.dart';
import 'register_page.dart';
import 'widget/auth_background.dart';
import 'widget/auth_animation.dart';
import 'widget/login_form.dart';
import 'widget/login_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final formCtrl = Get.put(LoginFormController());

    Future<void> onLogin() async {
      if (!formCtrl.formKey.currentState!.validate()) return;

      await auth.login(formCtrl.emailCtrl.text.trim(), formCtrl.passCtrl.text);
    }

    return Scaffold(
      body: AuthBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const AuthAnimation(asset: 'assets/anim/Phoenix Dancing.json'),
                const SizedBox(height: 16),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Welcome Back',
                          speed: const Duration(milliseconds: 80),
                          textStyle: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    const LoginForm(),
                    const SizedBox(height: 24),

                    LoginButton(onPressed: onLogin, text: 'تسجيل الدخول'),

                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: () {
                        Get.to(
                          () => const RegisterPage(),
                          transition: Transition.fade,
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 500),
                        );
                      },
                      child: const Text(
                        'إنشاء حساب جديد',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
