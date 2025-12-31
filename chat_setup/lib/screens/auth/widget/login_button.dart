// ignore_for_file: deprecated_member_use

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

    return Obx(() {
      final isLoading = auth.isLoading.value;
      final isSuccess = auth.loginSuccess.value;

      return GestureDetector(
        onTap: isLoading || isSuccess ? null : onPressed,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: isLoading || isSuccess ? 0.85 : 1,
          child: Container(
            height: 54,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeIn,
                child: isLoading
                    ? SizedBox(
                        key: const ValueKey('loading'),
                        height: 42,
                        child: Lottie.asset(
                          'assets/anim/loading.json',
                          fit: BoxFit.contain,
                        ),
                      )
                    : isSuccess
                    ? SizedBox(
                        key: const ValueKey('success'),
                        height: 42,
                        child: Lottie.asset(
                          'assets/anim/Confirm.json',
                          repeat: false,
                          fit: BoxFit.contain,
                        ),
                      )
                    : const Text(
                        'تسجيل الدخول',
                        key: ValueKey('text'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
