import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/chat_service.dart';
import '../../core/models/message_model.dart';

class ChatController extends GetxController {
  final ChatService _service = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
  // Actions
  // ======================

  Future<void> sendMessage({
    required String chatId,
    required String text,
    required List<String> members,
  }) async {
    if (uid == null) return;

    final message = MessageModel(
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
}
