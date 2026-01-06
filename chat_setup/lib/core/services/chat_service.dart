import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/message_model.dart';
import '../utils/password_helper.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _chats => _firestore.collection('chats');

  // Cache لتقليل reads
  final Map<String, bool> _userExistsCache = {};

  String getChatId(String a, String b) {
    final ids = [a, b]..sort();
    return ids.join('_');
  }

  // ======================
  // Messages (لا side-effects)
  // ======================
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _chats
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // لو ما زلت محتاج تنظيف الأعضاء، استدعيه مرة واحدة عند فتح الشات (من Controller/UI)
  Future<void> refreshMembersIfNeeded(String chatId) async {
    await _filterDeletedUsers(chatId);
  }

  Future<void> ensureChatExists({
    required String chatId,
    required List<String> members,
  }) async {
    final validMembers = await _verifyMembersExist(members);
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
        // per-user maps (اختياري)
        'muted': <String, bool>{},
        'deletedFor': <String, bool>{},
      });
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required MessageModel message,
    required List<String> members,
  }) async {
    final validMembers = await _verifyMembersExist(members);
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

  // ======================
  // Seen (Batch + Limit)
  // ======================
  Future<void> markMessagesAsSeen(String chatId, String myId) async {
    final q = await _chats
        .doc(chatId)
        .collection('messages')
        // الأفضل لو عندك receiverId: .where('receiverId', isEqualTo: myId)
        .where('senderId', isNotEqualTo: myId)
        .where('isSeen', isEqualTo: false)
        .limit(200)
        .get();

    if (q.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final d in q.docs) {
      batch.update(d.reference, {'isSeen': true});
    }
    await batch.commit();
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
  // Mute / Delete (per-user)
  // ======================
  Future<void> muteChatForUser({
    required String chatId,
    required String userId,
    required bool muted,
  }) async {
    await _chats.doc(chatId).set({
      'muted': {userId: muted},
    }, SetOptions(merge: true));
  }

  Future<void> deleteChatForUser({
    required String chatId,
    required String userId,
    required bool deleted,
  }) async {
    await _chats.doc(chatId).set({
      'deletedFor': {userId: deleted},
    }, SetOptions(merge: true));
  }

  // ======================
  // Helpers
  // ======================
  Future<List<String>> _verifyMembersExist(List<String> members) async {
    final validMembers = <String>[];

    for (final memberId in members.toSet()) {
      // cache hit
      final cached = _userExistsCache[memberId];
      if (cached == true) {
        validMembers.add(memberId);
        continue;
      }
      if (cached == false) {
        continue;
      }

      try {
        final userDoc = await _firestore
            .collection('users')
            .doc(memberId)
            .get();
        final exists = userDoc.exists;
        _userExistsCache[memberId] = exists;
        if (exists) validMembers.add(memberId);
      } catch (e) {
        _userExistsCache[memberId] = false;
        if (kDebugMode) {
          // ignore: avoid_print
          print('User check failed: $memberId => $e');
        }
      }
    }

    return validMembers;
  }

  Future<void> _filterDeletedUsers(String chatId) async {
    final chatDoc = await _chats.doc(chatId).get();
    if (!chatDoc.exists) return;

    final data = chatDoc.data() as Map<String, dynamic>?;
    final members = List<String>.from(data?['members'] ?? const <String>[]);

    if (members.isEmpty) return;

    final validMembers = await _verifyMembersExist(members);

    if (validMembers.length != members.length) {
      await _chats.doc(chatId).update({'members': validMembers});
    }
  }

  // ======================
  // Extra helpers (minimal & safe)
  // ======================
  Future<void> attachFileToLastMessage({
    required String chatId,
    required String fileUrl,
    required String senderId,
  }) async {
    final q = await _chats
        .doc(chatId)
        .collection('messages')
        .where('senderId', isEqualTo: senderId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (q.docs.isEmpty) return;

    await q.docs.first.reference.update({'fileUrl': fileUrl});
  }

  /// mute per user
  Future<void> muteChat({
    required String chatId,
    required String userId,
    required bool muted,
  }) async {
    await _chats.doc(chatId).set({
      'muted': {userId: muted},
    }, SetOptions(merge: true));
  }

  /// delete for user
  // Future<void> deleteChatForUser({
  //   required String chatId,
  //   required String userId,
  //   required bool deleted,
  // }) async {
  //   await _chats.doc(chatId).set(
  //     {
  //       'deletedFor': {userId: deleted}
  //     },
  //     SetOptions(merge: true),
  //   );
  // }
}
