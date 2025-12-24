import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/models/user_model.dart';
import '../../core/services/user_service.dart';

class UserController extends GetxController {
  final UserService _service = UserService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get uid => _auth.currentUser?.uid;

  Rx<UserModel?> user = Rx<UserModel?>(null);
  RxList<UserModel> allUsers = <UserModel>[].obs;
  RxList<UserModel> filteredUsers = <UserModel>[].obs;

  // ======================
  // Lifecycle
  // ======================

  @override
  void onInit() {
    super.onInit();

    if (uid != null) {
      loadUser(uid!);
      loadAllUsers(uid!);
      setOnline(true);
    }
  }

  @override
  void onClose() {
    setOnline(false);
    super.onClose();
  }

  // ======================
  // User data
  // ======================

  /// 👤 المستخدم الحالي
  Future<void> loadUser(String uid) async {
    user.value = await _service.getUser(uid);
  }

  /// 👥 كل المستخدمين (ما عدا أنا)
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

  // ======================
  // Online / Offline
  // ======================

  Future<void> setOnline(bool online) async {
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).set({
      'isOnline': online,
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// 🔴 Stream حالة مستخدم
  Stream<DocumentSnapshot> userStatusStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots();
  }

  // ======================
  // Clear
  // ======================

  void clear() {
    user.value = null;
    allUsers.clear();
    filteredUsers.clear();
  }
}
