import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../core/models/channel_model.dart';
import '../../core/models/message_model.dart';
import '../../core/services/channel_service.dart';
import '../../core/services/permission_service.dart';
import '../user/user_controller.dart';

class ChannelController extends GetxController {
  final ChannelService _service = ChannelService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserController _userController = Get.find<UserController>();

  String? get uid => _auth.currentUser?.uid;

  Future<void> createChannel(String name, String description) async {
    final myId = uid;
    if (myId == null) return;

    final currentUser = _userController.user.value;
    if (currentUser == null) return;

    if (!PermissionService.canCreateChannel(currentUser)) {
      Get.snackbar('خطأ', 'خطة اشتراكك لا تسمح بإنشاء قنوات');
      return;
    }

    final docRef = FirebaseFirestore.instance.collection('channels').doc();
    final newChannel = ChannelModel(
      id: docRef.id,
      name: name,
      description: description,
      ownerId: myId,
      admins: [myId],
      createdAt: DateTime.now(),
    );

    await _service.createChannel(newChannel);
  }

  Future<void> subscribeToChannel(String channelId) async {
    final myId = uid;
    if (myId == null) return;

    await FirebaseFirestore.instance.collection('channels').doc(channelId).update({
      'subscribers': FieldValue.arrayUnion([myId]),
    });
  }

  Future<void> unsubscribeFromChannel(String channelId) async {
    final myId = uid;
    if (myId == null) return;

    await FirebaseFirestore.instance.collection('channels').doc(channelId).update({
      'subscribers': FieldValue.arrayRemove([myId]),
    });
  }

  Future<void> broadcastMessage(String channelId, String text) async {
    final myId = uid;
    if (myId == null) return;

    // Verify if user is admin or owner
    final channelDoc = await FirebaseFirestore.instance.collection('channels').doc(channelId).get();
    if (!channelDoc.exists) return;

    final admins = List<String>.from(channelDoc.data()?['admins'] ?? []);
    final ownerId = channelDoc.data()?['ownerId'];

    if (myId != ownerId && !admins.contains(myId)) {
      Get.snackbar('خطأ', 'ليس لديك صلاحية للنشر في هذه القناة');
      return;
    }

    await sendChannelMessage(channelId, text);
  }

  Stream<List<ChannelModel>> get allChannels => _service.getChannels();

  Future<void> sendChannelMessage(String channelId, String text) async {
    final myId = uid;
    if (myId == null) return;

    final message = MessageModel(
      id: '',
      text: text,
      senderId: myId,
      senderName: _auth.currentUser?.displayName ?? 'مستخدم',
      receiverId: '', // Channels don't have a single receiver
      createdAt: DateTime.now(),
      isSeen: false,
    );

    await _service.sendChannelMessage(channelId: channelId, message: message);
  }

  Stream<QuerySnapshot> getChannelMessages(String channelId) =>
      _service.getChannelMessages(channelId);
}
