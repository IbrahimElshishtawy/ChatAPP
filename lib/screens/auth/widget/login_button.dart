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

      return GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: isLoading ? 0.85 : 1,
          child: Container(
            height: 54,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),

              // 🎨 Gradient احترافي
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              ),

              // 🌫 Shadow ناعم
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                splashColor: Colors.white.withOpacity(0.15),
                highlightColor: Colors.white.withOpacity(0.08),
                onTap: isLoading ? null : onPressed,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOut,
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
          ),
        ),
      );
    });
  }
}
