import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/services/chat_service.dart';
import '../../core/models/message_model.dart';

class ChatController extends GetxController {
  final ChatService _service = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // =========================
  // Chat helpers
  // =========================

  String openChat(String otherUserId) {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not logged in');

    final ids = [uid, otherUserId]..sort();
    return ids.join('_');
  }

  // =========================
  // Streams
  // =========================

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStream(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<String> getLastMessageStream(String chatId) {
    return _service.lastMessage(chatId);
  }

  Stream<int> getUnreadMessagesStream(String chatId) {
    if (currentUserId == null) return Stream.value(0);
    return _service.unreadCount(chatId, currentUserId!);
  }

  // =========================
  // Actions
  // =========================

  Future<void> send(String chatId, String text, List<String> members) async {
    final uid = currentUserId;
    if (uid == null) return;

    final message = MessageModel(
      text: text,
      senderId: uid,
      createdAt: DateTime.now(),
      isSeen: false,
    );

    await _service.sendMessage(
      chatId: chatId,
      message: message,
      members: members,
    );
  }

  Future<void> markSeen(String chatId) async {
    if (currentUserId == null) return;
    await _service.markMessagesAsSeen(chatId, currentUserId!);
  }

  Future<void> sendMessage({
    required String chatId,
    required String text,
    required List<String> members,
  }) async {
    return send(chatId, text, members);
  }
}
