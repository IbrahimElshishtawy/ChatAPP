import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';
import '../utils/password_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _chats => _firestore.collection('chats');

  // chatId ثابت
  String getChatId(String a, String b) {
    final ids = [a, b]..sort();
    return ids.join('_');
  }

  // ======================
  // Messages
  // ======================

  Stream<QuerySnapshot> getMessages(String chatId) {
    return _chats
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          // تحقق من الأعضاء المحذوفين في الدردشة
          _filterDeletedUsers(chatId); // تحقق من الأعضاء المحذوفين هنا
          return snapshot;
        });
  }

  Future<void> ensureChatExists({
    required String chatId,
    required List<String> members,
  }) async {
    // التحقق من أن الأعضاء جميعهم موجودين في Firebase Authentication و Firestore
    final validMembers = await _verifyMembersExist(members);

    // إذا كان هناك أعضاء غير موجودين، لا يتم إنشاء الشات
    if (validMembers.isEmpty) {
      throw Exception('Some members do not exist in Firebase');
    }

    final ref = _chats.doc(chatId);
    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({
        'members': validMembers,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTime': null,
        'hasPassword': false,
      });
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required MessageModel message,
    required List<String> members,
  }) async {
    final validMembers = await _verifyMembersExist(members);

    // إذا كان هناك أعضاء غير موجودين، لا يتم إرسال الرسالة
    if (validMembers.isEmpty) {
      throw Exception('Some members do not exist in Firebase');
    }

    final chatRef = _chats.doc(chatId);

    await chatRef.set({
      'members': validMembers,
      'lastMessage': message.text,
      'lastMessageTime': Timestamp.fromDate(message.createdAt),
    }, SetOptions(merge: true));

    await chatRef.collection('messages').add(message.toMap());
  }

  Future<void> markMessagesAsSeen(String chatId, String myId) async {
    final q = await _chats
        .doc(chatId)
        .collection('messages')
        .where('senderId', isNotEqualTo: myId)
        .where('isSeen', isEqualTo: false)
        .get();

    for (var d in q.docs) {
      d.reference.update({'isSeen': true});
    }
  }

  // ======================
  // Typing
  // ======================

  Stream<bool> typingStream({
    required String otherUserId,
    required String myId,
  }) {
    return _firestore
        .collection('users')
        .doc(otherUserId)
        .snapshots()
        .map((doc) => doc.data()?['typingTo'] == myId);
  }

  Future<void> setTyping({
    required String myId,
    required String? typingTo,
  }) async {
    await _firestore.collection('users').doc(myId).update({
      'typingTo': typingTo,
    });
  }

  // ======================
  // Password
  // ======================

  Future<void> setChatPassword(String chatId, String password) async {
    await _chats.doc(chatId).update({
      'hasPassword': true,
      'passwordHash': PasswordHelper.hash(password),
    });
  }

  // ======================
  // Helper Functions
  // ======================

  /// التحقق من أن الأعضاء الموجودين في الدردشة هم فقط الموجودين في Firestore
  Future<List<String>> _verifyMembersExist(List<String> members) async {
    final validMembers = <String>[];

    // تحقق من أن كل عضو موجود في Firestore
    for (var memberId in members) {
      try {
        // إذا كان المستخدم موجود في Firestore
        final userDoc = await _firestore
            .collection('users')
            .doc(memberId)
            .get();

        if (userDoc.exists) {
          validMembers.add(memberId);
        }
      } catch (e) {
        // إذا لم يكن المستخدم موجودًا في Firestore، لا نضيفه في القائمة
        print('User not found in Firestore: $memberId');
      }
    }

    return validMembers;
  }

  // دالة للتحقق من الأعضاء المحذوفين
  Future<void> _filterDeletedUsers(String chatId) async {
    final chatDoc = await _chats.doc(chatId).get();
    if (!chatDoc.exists) return;

    final members = List<String>.from(
      (chatDoc.data() as Map<String, dynamic>?)?['members'] ?? [],
    );
    final validMembers = await _verifyMembersExist(members);

    // إذا كان هناك أعضاء محذوفين، قم بتحديث القائمة
    if (validMembers.length != members.length) {
      await _chats.doc(chatId).update({'members': validMembers});
    }
  }
}
