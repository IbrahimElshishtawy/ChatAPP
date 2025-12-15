import 'package:chat/controllers/call/call_controller.dart';
import 'package:chat/controllers/navigation/navigation_controller.dart';
import 'package:get/get.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../controllers/user/user_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(UserController(), permanent: true);
    Get.put(NavigationController(), permanent: true);
    Get.put(CallController(), permanent: true);
  }
}
