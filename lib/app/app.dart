import 'package:chat/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme/theme_controller.dart';
import '../core/theme/app_theme.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeCtrl.themeMode,
        initialRoute: AppRoutes.splash,
        getPages: AppRoutes.pages,
      ),
    );
  }
}
