import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth/auth_controller.dart';
import 'login_button.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    Future<void> onRegister() async {
      if (nameCtrl.text.isEmpty ||
          emailCtrl.text.isEmpty ||
          passCtrl.text.isEmpty) {
        Get.snackbar('خطأ', 'من فضلك أدخل جميع البيانات');
        return;
      }

      await auth.register(emailCtrl.text.trim(), passCtrl.text, {
        'name': nameCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
        'role': 'user',
        'createdAt': DateTime.now(),
      });
    }

    return Column(
      children: [
        TextField(
          controller: nameCtrl,
          decoration: _decoration(
            context,
            label: 'الاسم',
            icon: Icons.person_rounded,
          ),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: _decoration(
            context,
            label: 'البريد الإلكتروني',
            icon: Icons.email_rounded,
          ),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: passCtrl,
          obscureText: true,
          decoration: _decoration(
            context,
            label: 'كلمة المرور',
            icon: Icons.lock_rounded,
          ),
        ),

        const SizedBox(height: 24),

        LoginButton(text: 'إنشاء حساب', onPressed: onRegister),
      ],
    );
  }

  InputDecoration _decoration(
    BuildContext context, {
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.4,
        ),
      ),
    );
  }
}
