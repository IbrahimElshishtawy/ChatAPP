import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_form_controller.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required TextEditingController emailCtrl,
    required TextEditingController passCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.put(LoginFormController());

    return Form(
      key: c.formKey,
      child: Column(
        children: [
          Obx(() {
            final v = c.isEmailValid.value; // null / true / false

            IconData? icon;
            Color? color;

            if (v == true) {
              icon = Icons.verified_rounded;
              color = Colors.green;
            } else if (v == false) {
              icon = Icons.error_rounded;
              color = Colors.red;
            }

            return TextFormField(
              controller: c.emailCtrl,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'البريد الإلكتروني',
                hintText: 'example@email.com',
                prefixIcon: const Icon(Icons.email_rounded),
                suffixIcon: icon == null ? null : Icon(icon, color: color),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              validator: (value) {
                final text = (value ?? '').trim();
                if (text.isEmpty) return 'من فضلك أدخل البريد الإلكتروني';
                final ok = RegExp(
                  r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$',
                ).hasMatch(text);
                if (!ok) return 'البريد الإلكتروني غير صحيح';
                return null;
              },
            );
          }),

          const SizedBox(height: 16),

          Obx(() {
            return TextFormField(
              controller: c.passCtrl,
              obscureText: c.obscure.value,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                prefixIcon: const Icon(Icons.lock_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                suffixIcon: IconButton(
                  onPressed: c.toggleObscure,
                  icon: Icon(
                    c.obscure.value
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                  ),
                ),
              ),
              validator: (value) {
                final text = (value ?? '');
                if (text.isEmpty) return 'من فضلك أدخل كلمة المرور';
                if (text.length < 6) {
                  return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                }
                return null;
              },
            );
          }),

          const SizedBox(height: 10),

          // ✅ Remember me
          Obx(() {
            return Row(
              children: [
                Switch(value: c.rememberMe.value, onChanged: c.toggleRemember),
                const Text('تذكرني'),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // لاحقًا: صفحة Forgot Password
                  },
                  child: const Text('نسيت كلمة المرور؟'),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
