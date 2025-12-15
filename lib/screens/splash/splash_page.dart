import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../app/routes.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Obx(() {
      if (auth.user.value == null) {
        Future.microtask(() => Get.offAllNamed(AppRoutes.login));
      } else {
        Future.microtask(() => Get.offAllNamed(AppRoutes.home));
      }

      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    });
  }
}
