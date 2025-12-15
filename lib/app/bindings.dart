import 'package:get/get.dart';
import '../controllers/auth/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }
}
