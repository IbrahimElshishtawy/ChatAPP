import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/group_model.dart';
import '../../core/models/message_model.dart';
import '../../core/services/group_service.dart';
import '../../core/services/permission_service.dart';
import '../user/user_controller.dart';

class GroupController extends GetxController {
  final GroupService _service = GroupService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserController _userController = Get.find<UserController>();

  String? get uid => _auth.currentUser?.uid;

  Future<void> createGroup(String name, List<String> memberIds) async {
    final myId = uid;
    if (myId == null) return;

    final currentUser = _userController.user.value;
    if (currentUser == null) return;

    if (!PermissionService.canCreateGroup(currentUser)) {
      Get.snackbar('خطأ', 'خطة اشتراكك لا تسمح بإنشاء مجموعات');
      return;
    }

    if (memberIds.length > PermissionService.maxGroupMembers(currentUser)) {
      Get.snackbar('خطأ', 'لقد تجاوزت الحد الأقصى للأعضاء المسموح به في خطتك');
      return;
    }

    final docRef = FirebaseFirestore.instance.collection('groups').doc();
    final group = GroupModel(
      id: docRef.id,
      name: name,
      members: [myId, ...memberIds],
      admins: [myId],
      createdBy: myId,
      createdAt: DateTime.now(),
    );

    await _service.createGroup(group);
  }

  Future<void> addMember(String groupId, String userId) async {
    await _service.addMember(groupId, userId);
  }

  Future<void> removeMember(String groupId, String userId) async {
    await _service.removeMember(groupId, userId);
  }

  Future<void> sendGroupMessage(String groupId, String text) async {
    final myId = uid;
    if (myId == null) return;

    final message = MessageModel(
      id: '',
      text: text,
      senderId: myId,
      senderName: _auth.currentUser?.displayName ?? 'مستخدم',
      receiverId: '', // Group ID is in the path
      createdAt: DateTime.now(),
      isSeen: false,
    );

    await _service.sendGroupMessage(groupId: groupId, message: message);
  }

  Stream<QuerySnapshot> getGroupMessages(String groupId) =>
      _service.getGroupMessages(groupId);
}
