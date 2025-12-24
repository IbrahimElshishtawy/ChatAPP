import 'package:chat/core/utils/password_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class ChatService {
  final _firestore = FirebaseFirestore.instance;

  String getChatId(String a, String b) {
    return a.compareTo(b) < 0 ? '${a}_$b' : '${b}_$a';
  }

  CollectionReference chats() => _firestore.collection('chats');

  Stream<QuerySnapshot> getMessages(String chatId) {
    return chats()
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> sendMessage({
    required String chatId,
    required MessageModel message,
    required List<String> members,
  }) async {
    final chatRef = chats().doc(chatId);

    await chatRef.set({
      'members': members,
      'lastMessage': message.text,
      'lastMessageTime': Timestamp.fromDate(message.createdAt),
    }, SetOptions(merge: true));

    await chatRef.collection('messages').add(message.toMap());
  }

  Future<void> markMessagesAsSeen(String chatId, String userId) async {
    final query = await chats()
        .doc(chatId)
        .collection('messages')
        .where('senderId', isNotEqualTo: userId)
        .where('isSeen', isEqualTo: false)
        .get();

    for (var doc in query.docs) {
      doc.reference.update({'isSeen': true});
    }
  }

  Future<void> setChatPassword({
    required String chatId,
    required String password,
  }) async {
    await chats().doc(chatId).update({
      'hasPassword': true,
      'passwordHash': PasswordHelper.hash(password),
    });
  }

  Future<void> removeChatPassword(String chatId) async {
    await chats().doc(chatId).update({
      'hasPassword': false,
      'passwordHash': FieldValue.delete(),
    });
  }

  Future<Map<String, dynamic>?> getChatSecurity(String chatId) async {
    final doc = await chats().doc(chatId).get();
    if (!doc.exists) return null;
    return doc.data() as Map<String, dynamic>;
  }

  Stream<int> unreadCount(String chatId, String userId) {
    return chats()
        .doc(chatId)
        .collection('messages')
        .where('senderId', isNotEqualTo: userId)
        .where('isSeen', isEqualTo: false)
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  Stream<String> lastMessage(String chatId) {
    return chats()
        .doc(chatId)
        .snapshots()
        .map((doc) => doc['lastMessage'] ?? '');
  }

  Future<void> ensureChatExists({
    required String chatId,
    required List<String> members,
  }) async {
    final ref = FirebaseFirestore.instance.collection('chats').doc(chatId);
    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({
        'members': members,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
      });
    }
  }
}
