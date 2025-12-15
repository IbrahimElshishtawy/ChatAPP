import 'package:chat/core/utils/password_helper.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/chat_service.dart';
import '../../core/models/message_model.dart';

class ChatController extends GetxController {
  final ChatService _service = ChatService();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  RxString activeChatId = ''.obs;

  String openChat(String otherUserId) {
    final chatId = _service.getChatId(currentUserId, otherUserId);
    activeChatId.value = chatId;
    return chatId;
  }

  Stream getMessagesStream(String chatId) {
    return _service.getMessages(chatId);
  }

  Future<void> send(String chatId, String text, List<String> members) async {
    final msg = MessageModel(
      id: '',
      senderId: currentUserId,
      text: text,
      createdAt: DateTime.now(),
      isSeen: false,
    );

    await _service.sendMessage(chatId: chatId, message: msg, members: members);
  }

  Future<void> markSeen(String chatId) async {
    await _service.markMessagesAsSeen(chatId, currentUserId);
  }

  Future<bool> canOpenChat(String chatId, String enteredPassword) async {
    final data = await _service.getChatSecurity(chatId);
    if (data == null) return false;

    final hasPassword = data['hasPassword'] ?? false;
    if (!hasPassword) return true;

    final hash = data['passwordHash'];
    return PasswordHelper.verify(enteredPassword, hash);
  }

  Stream<int> getUnread(String chatId) {
    return _service.unreadCount(chatId, currentUserId);
  }

  Stream<String> getLastMessage(String chatId) {
    return _service.lastMessage(chatId);
  }
}
