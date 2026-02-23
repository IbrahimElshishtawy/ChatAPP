import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final RxBool isDark = false.obs;
  static const _themeKey = 'isDarkMode';

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  ThemeMode get mode => isDark.value ? ThemeMode.dark : ThemeMode.light;

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDark.value = prefs.getBool(_themeKey) ?? false;
    Get.changeThemeMode(mode);
  }

  Future<void> toggleTheme() async {
    isDark.toggle();
    Get.changeThemeMode(mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark.value);
  }
}
