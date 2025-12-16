import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../controllers/auth/auth_controller.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: auth.isLoading.value ? null : onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: auth.isLoading.value
              ? Lottie.asset('assets/anim/loading.json', height: 40)
              : const Text('تسجيل الدخول', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
