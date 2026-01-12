import 'package:chat_setup/controllers/social/friend_controller.dart';
import 'package:get/get.dart';

class FriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FriendController>(() => FriendController(), fenix: true);
  }
}
