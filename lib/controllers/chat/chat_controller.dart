import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ❌ لا تعمل ! هنا
  String? get currentUserId => _auth.currentUser?.uid;

  /// فتح شات
  String openChat(String otherUserId) {
    final uid = currentUserId;
    if (uid == null) {
      throw Exception('User not logged in');
    }

    final ids = [uid, otherUserId]..sort();
    return ids.join('_');
  }

  /// Stream الرسائل
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// إرسال رسالة
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

  /// تعليم الرسائل كمقروءة
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
}
