import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/chat_service.dart';
import '../../core/models/message_model.dart';

class ChatController extends GetxController {
  final ChatService _service = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ✅ UID الحالي
  String? get uid => _auth.currentUser?.uid;

  // ======================
  // Streams
  // ======================

  Stream getMessages(String chatId) {
    return _service.getMessages(chatId);
  }

  Stream<String> lastMessage(String chatId) {
    return _service.lastMessage(chatId);
  }

  Stream<int> unreadCount(String chatId) {
    if (uid == null) return Stream.value(0);
    return _service.unreadCount(chatId, uid!);
  }

  // ======================
  // Chat helpers
  // ======================

  String openChat(String otherUserId) {
    if (uid == null) {
      throw Exception('User not logged in');
    }
    return _service.getChatId(uid!, otherUserId);
  }

  Future<void> openOrCreateChat(String otherUserId) async {
    if (uid == null) return;

    final chatId = _service.getChatId(uid!, otherUserId);

    await _service.ensureChatExists(
      chatId: chatId,
      members: [uid!, otherUserId],
    );
  }

  Future<void> ensureChat({
    required String chatId,
    required List<String> members,
  }) async {
    final ref = _service.chats().doc(chatId);
    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({
        'members': members,
        'createdAt': DateTime.now(),
        'lastMessage': '',
      });
    }
  }

  // ======================
  // Actions
  // ======================

  Future<void> sendMessage({
    required String chatId,
    required String text,
    required List<String> members,
  }) async {
    if (uid == null) return;

    final message = MessageModel(
      id: '',
      text: text,
      senderId: uid!,
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
    if (uid == null) return;
    await _service.markMessagesAsSeen(chatId, uid!);
  }

  ///  Last message stream (for Home page)
  Stream<String> getLastMessageStream(String chatId) {
    return _service.lastMessage(chatId);
  }

  /// connectivity check
  void setTyping({required String chatId, required bool isTyping}) {
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'typingTo': isTyping ? chatId : null,
    });
  }
}
