import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // =========================
  // Chat helpers
  // =========================

  bool canOpenChat(String otherUserId, [String? password]) {
    final uid = currentUserId;
    if (uid == null) return false;
    return uid != otherUserId;
  }

  String openChat(String otherUserId) {
    final uid = currentUserId;
    if (uid == null) {
      throw Exception('User not logged in');
    }

    final ids = [uid, otherUserId]..sort();
    return ids.join('_');
  }

  // =========================
  // Messages
  // =========================

  // Stream for Messages
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> send(String chatId, String text, List<String> members) async {
    final uid = currentUserId;
    if (uid == null) return;

    await _firestore.collection('chats').doc(chatId).collection('messages').add(
      {
        'text': text,
        'senderId': uid,
        'members': members,
        'createdAt': FieldValue.serverTimestamp(),
        'seenBy': [uid],
      },
    );
  }

  Future<void> markSeen(String chatId) async {
    final uid = currentUserId;
    if (uid == null) return;

    final snap = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('seenBy', arrayContains: uid)
        .get();

    for (final doc in snap.docs) {
      doc.reference.update({
        'seenBy': FieldValue.arrayUnion([uid]),
      });
    }
  }

  // =========================
  // Home screen helpers
  // =========================

  /// Stream for Last Message
  Stream<String> getLastMessageStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return '';
          final data = snapshot.docs.first.data();
          return (data['text'] ?? '') as String;
        });
  }

  /// Stream for Unread Messages
  Stream<int> getUnreadMessagesStream(String chatId) {
    final uid = currentUserId;
    if (uid == null) return Stream.value(0);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('seenBy', isNotEqualTo: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
