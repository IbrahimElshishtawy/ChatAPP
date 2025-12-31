import 'package:get/get.dart';
import '../../controllers/navigation/navigation_controller.dart';
import '../../controllers/chat/chat_controller.dart';
import '../../controllers/user/user_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationController(), fenix: true);
    Get.lazyPut(() => ChatController(), fenix: true);
    Get.lazyPut(() => UserController(), fenix: true);
  }
}
