import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
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

  Future<UserModel?> getUser(String uid) async {
    return await _service.getUser(uid);
  }

  /// 👥 كل المستخدمين (ما عدا أنا)
  Future<void> loadAllUsers(String myUid) async {
    final users = await _service.getAllUsers();
    final others = users.where((u) => u.id != myUid).toList();

    allUsers.assignAll(others);
    filteredUsers.assignAll(others);
  }

  void search(String q) {
    if (q.trim().isEmpty) {
      filteredUsers.assignAll(
        allUsers,
      ); // إذا كانت القيمة فارغة نعرض كل المستخدمين
      return;
    }

    final query = q.toLowerCase();

    filteredUsers.assignAll(
      allUsers.where(
        (u) =>
            u.name.toLowerCase().contains(query) || // البحث حسب الاسم
            (u.email?.toLowerCase().contains(query) ??
                false) || // البحث حسب الإيميل
            (u.phone?.contains(query) ?? false) || // البحث حسب الرقم
            (u.username?.toLowerCase().contains(query) ??
                false), // البحث حسب اسم المستخدم
      ),
    );
  }

  /// ✏️ تعديل البروفايل
  Future<void> updateProfile({
    String? name,
    String? description,
    String? websiteLink,
    String? username,
  }) async {
    if (user.value == null) return;

    final updated = user.value!.copyWith(
      name: name,
      description: description,
      websiteLink: websiteLink,
      username: username,
    );
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

  //=============================================================
  // تحديث الصورة الشخصية
  Future<void> updateProfilePicture(File imageFile) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('$userId.jpg');
      await storageRef.putFile(imageFile);

      final imageUrl = await storageRef.getDownloadURL();

      await _firestore.collection('users').doc(userId).update({
        'profilePicture': imageUrl,
      });

      user.value = user.value?.copyWith(profilePicture: imageUrl);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating profile picture: $e');
      }
    }
  }

  // تحديث صورة الخلفية
  Future<void> updateBackgroundImage(File imageFile) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('background_images')
          .child('$userId.jpg');
      await storageRef.putFile(imageFile);

      final imageUrl = await storageRef.getDownloadURL();

      await _firestore.collection('users').doc(userId).update({
        'backgroundImage': imageUrl,
      });

      user.value = user.value?.copyWith(backgroundImage: imageUrl);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating background image: $e');
      }
    }
  }

  // تحديث الروابط
  Future<void> updateProfileLinks({
    String? linkedin,
    String? facebook,
    String? instagram,
    String? whatsapp,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _firestore.collection('users').doc(userId).update({
        'linkedin': linkedin,
        'facebook': facebook,
        'instagram': instagram,
        'whatsapp': whatsapp,
      });

      user.value = user.value?.copyWith(
        linkedin: linkedin,
        facebook: facebook,
        instagram: instagram,
        whatsapp: whatsapp,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error updating profile links: $e');
      }
    }
  }

  // Blocking logic
  Future<void> blockUser(String userId) async {
    if (user.value == null) return;
    final blocked = List<String>.from(user.value!.blockedUsers)..add(userId);
    final updated = user.value!.copyWith(blockedUsers: blocked);
    await _service.updateUser(updated);
    user.value = updated;
  }

  Future<void> unblockUser(String userId) async {
    if (user.value == null) return;
    final blocked = List<String>.from(user.value!.blockedUsers)..remove(userId);
    final updated = user.value!.copyWith(blockedUsers: blocked);
    await _service.updateUser(updated);
    user.value = updated;
  }

  Future<void> blockCall(String userId) async {
    if (user.value == null) return;
    final blocked = List<String>.from(user.value!.blockedCalls)..add(userId);
    final updated = user.value!.copyWith(blockedCalls: blocked);
    await _service.updateUser(updated);
    user.value = updated;
  }

  Future<void> unblockCall(String userId) async {
    if (user.value == null) return;
    final blocked = List<String>.from(user.value!.blockedCalls)..remove(userId);
    final updated = user.value!.copyWith(blockedCalls: blocked);
    await _service.updateUser(updated);
    user.value = updated;
  }

  Future<void> blockGroup(String groupId) async {
    if (user.value == null) return;
    final blocked = List<String>.from(user.value!.blockedGroups)..add(groupId);
    final updated = user.value!.copyWith(blockedGroups: blocked);
    await _service.updateUser(updated);
    user.value = updated;
  }

  Future<void> unblockGroup(String groupId) async {
    if (user.value == null) return;
    final blocked = List<String>.from(user.value!.blockedGroups)..remove(groupId);
    final updated = user.value!.copyWith(blockedGroups: blocked);
    await _service.updateUser(updated);
    user.value = updated;
  }

  Future<void> updatePrivacySettings(Map<String, dynamic> settings) async {
    if (user.value == null) return;
    final updated = user.value!.copyWith(privacySettings: settings);
    await _service.updateUser(updated);
    user.value = updated;
  }

  Future<void> updateProfessionalDetails({
    String? industry,
    String? company,
    String? jobTitle,
    String? professionalBio,
  }) async {
    if (user.value == null) return;

    final updated = user.value!.copyWith(
      industry: industry,
      company: company,
      jobTitle: jobTitle,
      professionalBio: professionalBio,
    );
    await _service.updateUser(updated);
    user.value = updated;
  }

  Future<void> requestVerification(String reason) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('verification_requests').doc(uid).set({
      'uid': uid,
      'name': user.value?.name,
      'reason': reason,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteUserAccount() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // In a real app, you'd also delete user data from Firestore and Storage
    await _firestore.collection('users').doc(uid).delete();
    await _auth.currentUser?.delete();
    clear();
  }
}
