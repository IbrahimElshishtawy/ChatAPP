import 'package:chat/controllers/call/Call_History_Controller.dart';
import 'package:chat/controllers/call/call_controller.dart';
import 'package:chat/controllers/chat/chat_controller.dart';
import 'package:chat/controllers/navigation/navigation_controller.dart';
import 'package:chat/controllers/settings/settings_controller.dart';
import 'package:chat/controllers/theme/theme_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController(), permanent: true);
    Get.put(NavigationController(), permanent: true);
    Get.put(ChatController(), permanent: true);
    Get.put(CallController(), permanent: true);
    Get.put(CallHistoryController(), permanent: true);
    Get.put(SettingsController(), permanent: true);
  }
}
