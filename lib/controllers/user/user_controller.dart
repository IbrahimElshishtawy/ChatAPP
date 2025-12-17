import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/models/user_model.dart';
import '../../core/services/user_service.dart';

class UserController extends GetxController {
  final UserService _service = UserService();

  /// 👤 المستخدم الحالي
  Rx<UserModel?> user = Rx<UserModel?>(null);

  /// 👥 كل المستخدمين
  RxList<UserModel> users = <UserModel>[].obs;

  /// 🔍 نتائج البحث
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

  /// تحميل المستخدم الحالي
  Future<void> loadUser(String uid) async {
    user.value = await _service.getUser(uid);
  }

  /// تحميل كل المستخدمين (ماعدا نفسي)
  Future<void> loadAllUsers(String myUid) async {
    final list = await _service.getAllUsers();

    users.assignAll(list.where((u) => u.id != myUid));

    filteredUsers.assignAll(users);
  }

  /// 🔍 البحث
  void search(String q) {
    if (q.isEmpty) {
      filteredUsers.assignAll(users);
    } else {
      filteredUsers.assignAll(
        users.where(
          (u) =>
              u.name.toLowerCase().contains(q.toLowerCase()) ||
              (u.email?.toLowerCase().contains(q.toLowerCase()) ?? false) ||
              (u.phone!.contains(q)),
        ),
      );
    }
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
    users.clear();
    filteredUsers.clear();
  }
}
