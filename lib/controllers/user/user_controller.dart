import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/models/user_model.dart';
import '../../core/services/user_service.dart';

class UserController extends GetxController {
  final UserService _service = UserService();
  Rx<UserModel?> user = Rx<UserModel?>(null);
  RxList<UserModel> filteredUsers = <UserModel>[].obs;
  @override
  void onInit() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      loadUser(uid);
    }
    super.onInit();
  }

  Future<void> loadUser(String uid) async {
    user.value = await _service.getUser(uid);
  }

  Future<void> updateProfile(String name) async {
    if (user.value == null) return;
    final updated = UserModel(
      id: user.value!.id,
      name: name,
      email: user.value!.email,
      role: user.value!.role,
    );
    await _service.updateUser(updated);
    user.value = updated;
  }

  void clear() {
    user.value = null;
  }
}
