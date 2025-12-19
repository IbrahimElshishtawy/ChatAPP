import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/models/user_model.dart';
import '../../core/services/user_service.dart';

class UserController extends GetxController {
  final UserService _service = UserService();

  Rx<UserModel?> user = Rx<UserModel?>(null);
  RxList<UserModel> allUsers = <UserModel>[].obs;
  RxList<UserModel> filteredUsers = <UserModel>[].obs;
  RxList<UserModel> users = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      loadUser(uid);
      loadAllUsers(uid);
    }
  }

  /// تحميل المستخدم الحالي
  Future<void> loadUser(String uid) async {
    user.value = await _service.getUser(uid);
  }

  /// تحميل كل المستخدمين (ماعدا نفسي)
  Future<void> loadAllUsers(String uid) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final users = await _service.getAllUsers();

    //  شيل نفسك من الليست
    allUsers.assignAll(users.where((u) => u.id != uid));
    filteredUsers.assignAll(allUsers);
  }

  ///  البحث
  void search(String q) {
    if (q.isEmpty) {
      filteredUsers.assignAll(allUsers);
    } else {
      filteredUsers.assignAll(
        allUsers.where(
          (u) =>
              u.name.toLowerCase().contains(q.toLowerCase()) ||
              u.email!.toLowerCase().contains(q.toLowerCase()) ||
              u.phone!.toLowerCase().contains(q.toLowerCase()),
        ),
      );
    }
  }

  /// تعديل البروفايل
  Future<void> updateProfile(String name) async {
    if (user.value == null) return;

    final updated = user.value!.copyWith(name: name);
    await _service.updateUser(updated);
    user.value = updated;
  }

  void clear() {
    user.value = null;
    users.clear();
    filteredUsers.clear();
  }
}
