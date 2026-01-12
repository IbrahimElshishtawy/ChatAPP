import 'package:get/get.dart';
import '../../controllers/social/friend_controller.dart';
import '../../controllers/social/follow_controller.dart';

class SocialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FriendController>(() => FriendController());
    Get.lazyPut<FollowController>(() => FollowController());
  }
}
