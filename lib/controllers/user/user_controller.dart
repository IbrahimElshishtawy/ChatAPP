import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/models/user_model.dart';
import '../../core/services/user_service.dart';

class UserController extends GetxController {
  final UserService _service = UserService();

  Rx<UserModel?> user = Rx<UserModel?>(null);
  RxList<UserModel> allUsers = <UserModel>[].obs;
  RxList<UserModel> filteredUsers = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      loadUser(uid);
      loadAllUsers(uid);
    }
  }

  /// 👤 تحميل المستخدم الحالي
  Future<void> loadUser(String uid) async {
    user.value = await _service.getUser(uid);
  }

  /// 👥 تحميل كل المستخدمين (ما عدا نفسي)
  Future<void> loadAllUsers(String myUid) async {
    final users = await _service.getAllUsers();

    final others = users.where((u) => u.id != myUid).toList();

    allUsers.assignAll(others);
    filteredUsers.assignAll(others);
  }

  /// 🔍 البحث
  void search(String q) {
    if (q.trim().isEmpty) {
      filteredUsers.assignAll(allUsers);
      return;
    }

    final query = q.toLowerCase();

    filteredUsers.assignAll(
      allUsers.where(
        (u) =>
            u.name.toLowerCase().contains(query) ||
            (u.email?.toLowerCase().contains(query) ?? false) ||
            (u.phone?.contains(query) ?? false),
      ),
    );
  }

  /// ✏️ تعديل البروفايل
  Future<void> updateProfile(String name) async {
    if (user.value == null) return;

    final updated = user.value!.copyWith(name: name);
    await _service.updateUser(updated);
    user.value = updated;
  }

  void clear() {
    user.value = null;
    allUsers.clear();
    filteredUsers.clear();
  }
}
