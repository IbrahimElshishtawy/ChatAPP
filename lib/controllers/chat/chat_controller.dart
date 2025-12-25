import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/chat_service.dart';
import '../../core/models/message_model.dart';

class ChatController extends GetxController {
  final ChatService _service = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ======================
  // Auth
  // ======================

  String? get uid => _auth.currentUser?.uid;

  // ======================
  // Streams
  // ======================

  Stream<QuerySnapshot> messagesStream(String chatId) {
    return _service.getMessages(chatId);
  }

  /// Alias علشان UI قديم
  Stream<QuerySnapshot> getMessages(String chatId) {
    return messagesStream(chatId);
  }

  Stream<String> getLastMessageStream(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .snapshots()
        .map((doc) => doc.data()?['lastMessage'] ?? '');
  }

  Stream<bool> typingStream(String otherUserId) {
    final myId = uid;
    if (myId == null) return const Stream.empty();
    return _service.typingStream(otherUserId: otherUserId, myId: myId);
  }

  // ======================
  // Core Chat Logic
  // ======================

  /// الدالة الأساسية الوحيدة لفتح/إنشاء شات
  Future<String> openChat(String otherUserId) async {
    final myId = uid;
    if (myId == null) {
      throw Exception('User not logged in');
    }

    final chatId = _service.getChatId(myId, otherUserId);

    // التحقق من أن الأعضاء ليسوا مكررين
    await _service.ensureChatExists(
      chatId: chatId,
      members: [myId, otherUserId],
    );

    return chatId;
  }

  // ======================
  // ALIASES (توافق كامل مع UI القديم)
  // ======================

  /// كان مستخدم في UI: openOrCreateChat(otherUserId)
  Future<String> openOrCreateChat(String otherUserId) {
    return openChat(otherUserId);
  }

  /// كان مستخدم في UI: openOrCreateChat(otherUserId: xxx)
  Future<String> openOrCreateChatNamed({required String otherUserId}) {
    return openChat(otherUserId);
  }

  /// كان مستخدم في UI: ensureChat(chatId: x, members: y)
  Future<void> ensureChat({
    required String chatId,
    required List<String> members,
  }) async {
    // التحقق من عدم تكرار الأعضاء
    final uniqueMembers = Set<String>.from(members);

    if (uniqueMembers.length != members.length) {
      throw Exception("Duplicate members detected");
    }

    await _service.ensureChatExists(chatId: chatId, members: members);
  }

  // ======================
  // Actions
  // ======================

  Future<void> sendMessage({
    required String chatId,
    required String text,
    required List<String> members,
  }) async {
    final myId = uid;
    if (myId == null) return;

    // التحقق من أن الأعضاء ليسوا مكررين
    final uniqueMembers = Set<String>.from(members);

    if (uniqueMembers.length != members.length) {
      throw Exception("Duplicate members detected");
    }

    final receiverId = members.firstWhere((id) => id != myId);

    final message = MessageModel(
      id: '',
      text: text,
      senderId: myId,
      receiverId: receiverId,
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
    final myId = uid;
    if (myId == null) return;
    await _service.markMessagesAsSeen(chatId, myId);
  }

  // ======================
  // Typing
  // ======================

  Future<void> startTyping(String otherUserId) async {
    final myId = uid;
    if (myId == null) return;
    await _service.setTyping(myId: myId, typingTo: otherUserId);
  }

  Future<void> stopTyping() async {
    final myId = uid;
    if (myId == null) return;
    await _service.setTyping(myId: myId, typingTo: null);
  }
}
