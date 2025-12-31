import 'package:chat_setup/screens/auth/widget/login_form_controller.dart';
import 'package:get/get.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginFormController>(() => LoginFormController(), fenix: true);
  }
}
