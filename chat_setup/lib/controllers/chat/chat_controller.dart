import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../core/models/message_model.dart';
import '../../core/services/chat_service.dart';
import '../../core/services/FileUploadService.dart';
import '../../core/services/AudioRecordingService.dart';
import '../../core/services/CameraService.dart';

class ChatController extends GetxController {
  final ChatService _service = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FileUploadService _fileService = FileUploadService();
  final AudioRecordingService _audioService = AudioRecordingService();
  final CameraService _cameraService = CameraService();

  String? get uid => _auth.currentUser?.uid;

  // ======================
  // Streams
  // ======================
  Stream getMessages(String chatId) => _service.getMessages(chatId);
  Stream messagesStream(String chatId) => _service.getMessages(chatId);

  /// ✅ FIXED: بدون الاعتماد على ChatService
  Stream<String> getLastMessageStream(String chatId) {
    return _service.getMessages(chatId).map((snapshot) {
      if (snapshot.docs.isEmpty) return '';
      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      return data['text']?.toString() ?? '';
    });
  }

  Stream<bool> typingStream(String otherUserId) {
    final myId = uid;
    if (myId == null) return const Stream.empty();
    return _service.typingStream(otherUserId: otherUserId, myId: myId);
  }

  // ======================
  // Chat lifecycle
  // ======================
  Future<String> openChat(String otherUserId) async {
    final myId = uid;
    if (myId == null) {
      throw Exception('User not logged in');
    }

    final chatId = _service.getChatId(myId, otherUserId);

    await _service.ensureChatExists(
      chatId: chatId,
      members: [myId, otherUserId],
    );

    await _service.refreshMembersIfNeeded(chatId);
    return chatId;
  }

  Future<String> openOrCreateChat(String otherUserId) => openChat(otherUserId);

  // ======================
  // Send text / file
  // ======================
  Future<void> sendMessage({
    required String chatId,
    required String text,
    required List<String> members,
    String messageType = 'text',
    String? fileUrl,
    String? forwardedFromId,
  }) async {
    final myId = uid;
    if (myId == null) return;

    final receiverId = members.firstWhere(
      (id) => id != myId,
      orElse: () => myId,
    );

    final message = MessageModel(
      id: '',
      text: text.trim(),
      senderId: myId,
      senderName: _auth.currentUser?.displayName ?? 'مستخدم',
      receiverId: receiverId,
      createdAt: DateTime.now(),
      messageType: messageType,
      fileUrl: fileUrl,
      forwardedFromId: forwardedFromId,
      isSeen: false,
    );

    await _service.sendMessage(
      chatId: chatId,
      message: message,
      members: members,
    );
  }

  Future<void> sendMediaMessage({
    required String chatId,
    required List<String> members,
    required File file,
    required String type, // image, video, audio, file
  }) async {
    final myId = uid;
    if (myId == null) return;

    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
    final fileUrl = await _fileService.uploadFile(
      file,
      'chat_media/$chatId/$type/$fileName',
    );

    await sendMessage(
      chatId: chatId,
      text: '[ $type ]',
      members: members,
      messageType: type,
      fileUrl: fileUrl,
    );
  }

  Future<void> sendFileMessage({
    required String chatId,
    required String text,
    required List<String> members,
    required String filePath,
  }) async {
    await sendMediaMessage(
      chatId: chatId,
      members: members,
      file: File(filePath),
      type: 'file',
    );
  }

  Future<void> editMessage({
    required String chatId,
    required String messageId,
    required String newText,
  }) async {
    final myId = uid;
    if (myId == null) return;

    await _service.editMessage(
      chatId: chatId,
      messageId: messageId,
      newText: newText,
      userId: myId,
    );
  }

  Future<void> deleteForEveryone({
    required String chatId,
    required String messageId,
  }) async {
    final myId = uid;
    if (myId == null) return;

    await _service.deleteMessageForEveryone(
      chatId: chatId,
      messageId: messageId,
      userId: myId,
    );
  }

  Future<void> deleteForMe({
    required String chatId,
    required String messageId,
  }) async {
    final myId = uid;
    if (myId == null) return;

    await _service.deleteMessageForMe(
      chatId: chatId,
      messageId: messageId,
      userId: myId,
    );
  }

  Future<void> reportMessage({
    required String chatId,
    required String messageId,
    required String reason,
  }) async {
    final myId = uid;
    if (myId == null) return;

    await _service.reportMessage(
      chatId: chatId,
      messageId: messageId,
      reportedBy: myId,
      reason: reason,
    );
  }

  Future<void> forwardMessage({
    required String targetChatId,
    required List<String> targetMembers,
    required MessageModel originalMessage,
  }) async {
    final myId = uid;
    if (myId == null) return;

    await sendMessage(
      chatId: targetChatId,
      text: originalMessage.text,
      members: targetMembers,
      messageType: originalMessage.messageType,
      fileUrl: originalMessage.fileUrl,
      forwardedFromId: originalMessage.senderId,
    );
  }

  // ======================
  // Seen
  // ======================
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

  // ======================
  // Audio
  // ======================
  Future<void> startAudioRecording() async {
    await _audioService.startRecording();
  }

  Future<void> stopAudioRecordingAndSend({
    required String chatId,
    required List<String> members,
  }) async {
    final filePath = await _audioService.stopRecording();
    if (filePath == null) return;

    await sendFileMessage(
      chatId: chatId,
      text: 'رسالة صوتية',
      members: members,
      filePath: filePath,
    );
  }

  // ======================
  // Camera
  // ======================
  Future<void> openCamera() async {
    await _cameraService.initializeCamera();
    await _cameraService.captureImage();
  }

  // ======================
  // Delete / Mute
  // ======================
  Future<void> muteChat(String chatId, {bool muted = true}) async {
    final myId = uid;
    if (myId == null) return;
    await _service.muteChat(chatId: chatId, userId: myId, muted: muted);
  }

  Future<void> deleteChatForMe(String chatId, {bool deleted = true}) async {
    final myId = uid;
    if (myId == null) return;
    await _service.deleteChatForUser(
      chatId: chatId,
      userId: myId,
      deleted: deleted,
    );
  }

  // ======================
  // Compatibility Layer
  // ======================
  Future<void> deleteChat(String chatId) async {
    await deleteChatForMe(chatId);
  }

  Future<void> ensureChat({
    required String chatId,
    required List<String> members,
  }) async {
    await _service.ensureChatExists(chatId: chatId, members: members);
  }
}
